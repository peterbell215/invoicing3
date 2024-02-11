# frozen_string_literal: true

# Provides details of a client including address.
class Client < ApplicationRecord
  has_many :meetings, dependent: :destroy
  has_many :meeting_charges, dependent: :destroy

  # There must be at least one meeting charge setup for the client
  validates :name, :email, :address1, :town, presence: true
  validates :postcode, format: { with: /\A[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}\z/i, message: "is badly formed postcode" }

  validates :meeting_charges, presence: true
  validate :meeting_charges_must_not_overlap

  # Add a default meeting_charges record if none exists.
  after_initialize do |client|
    client.meeting_charges.build(from: Time.zone.today, hourly_charge_rate: 60) if client.meeting_charges.empty?
  end

  def as_json(options = {})
    # just in case someone says as_json(nil) and bypasses
    # our default...
    super((options || {}).merge({ methods: %i[current_rate] }))
  end

  # @return Money
  def current_rate
    self.current_meeting_charge&.hourly_charge_rate
  end

  # Sets the current rate for meetings if different from current rate as held in database.  Updates the
  # current rate in the database to be up to yesterday, and creates a new meeting_charges record starting
  # today with an open ended charge period.
  # @return [Money]
  def current_rate=(rate)
    active_meeting_charge = self.current_meeting_charge

    if active_meeting_charge.nil?
      # No record exists yet, so create a new one.
      _build_active_meeting_charge(rate)
    elsif active_meeting_charge.hourly_charge_rate != rate
      # Something has changed, so ...
      if active_meeting_charge.persisted?
        # If this is a persisted (ie existing) meeting_charge, then amend date period and add the new record.
        active_meeting_charge.update!(to: Time.zone.today - 1.day)
        _build_active_meeting_charge(rate)
      else
        # If not yet persisted, then update existing unsaved record.
        active_meeting_charge.hourly_charge_rate = rate
      end
    end
    rate
  end

  def _build_active_meeting_charge(rate)
    self.meeting_charges << MeetingCharge.new(from: Time.zone.today, to: nil, hourly_charge_rate: rate)
  end

  # Returns the current meeting_charge record.
  def current_meeting_charge
    if self.id
      self.meeting_charges.find_by(to: nil)
    else
      self.meeting_charges.find { |meeting_charge| meeting_charge.to.nil? }
    end
  end

  def meeting_charges_must_not_overlap
    overlap_error = MeetingCharge.overlap?(self.meeting_charges)

    return unless overlap_error

    self.errors.add(:meeting_charges, "meeting charge to #{overlap_error.to} overlaps with its successor")
  end
end
