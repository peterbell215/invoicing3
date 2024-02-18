# frozen_string_literal: true

# Provides details of a client including address.
class Client < ApplicationRecord
  has_many :meetings, dependent: :destroy
  has_many :prices, dependent: :destroy

  # There must be at least one mprice record setup for the client
  validates :name, :address1, :town, presence: true
  validates :email, presence: true, uniqueness: true
  validates :postcode, format: { with: /\A[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}\z/i, message: 'is badly formed postcode' }

  validates :prices, presence: true
  validate :prices_must_not_overlap

  # Add a default prices record if none exists.
  after_initialize do |client|
    client.prices.build(from: Time.zone.today, hourly_charge_rate: 60) if client.prices.empty?
  end

  def as_json(options = {})
    # just in case someone says as_json(nil) and bypasses
    # our default...
    super((options || {}).merge({ methods: %i[current_rate] }))
  end

  # @return Money
  def current_rate
    self.current_price&.hourly_charge_rate
  end

  def current_rate_as_dinero

  end

  # Sets the current price for meetings if different from current price as held in database.  Updates the
  # current rate in the database to be up to yesterday, and creates a new prices record starting
  # today with an open ended charge period.
  # @return [Money]
  def current_rate=(rate)
    active_price = self.current_price

    if active_price.nil?
      # No record exists yet, so create a new one.
      _build_active_price(rate)
    elsif active_price.hourly_charge_rate != rate
      # Something has changed, so ...
      if active_price.persisted?
        # If this is a persisted (ie existing) price, then amend date period and add the new record.
        active_price.update!(to: Time.zone.today - 1.day)
        _build_active_price(rate)
      else
        # If not yet persisted, then update existing unsaved record.
        active_price.hourly_charge_rate = rate
      end
    end
    rate
  end

  def _build_active_price(rate)
    self.prices << Price.new(from: Time.zone.today, to: nil, hourly_charge_rate: rate)
  end

  # Returns the current price record.
  def current_price
    if self.id
      self.prices.find_by(to: nil)
    else
      self.prices.find { |price| price.to.nil? }
    end
  end

  def prices_must_not_overlap
    overlap_error = Price.overlap?(self.prices)

    return unless overlap_error

    self.errors.add(:prices, "price to #{overlap_error.to} overlaps with its successor")
  end
end
