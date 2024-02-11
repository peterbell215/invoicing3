# frozen_string_literal: true

# This model represents the default charge that is applied to a specific client over a specific period.
class MeetingCharge < ApplicationRecord
  belongs_to :client

  monetize :hourly_charge_rate_pence

  # Checks if for the provided client_id any meeting charge entries' date ranges overlap.
  # @param [ActiveResult] meeting_charges
  # @return [MeetingCharge]
  def self.overlap?(meeting_charges)
    return false if meeting_charges.length <= 1

    overlapping_pair = meeting_charges.each_cons(2).find { |previous, following| previous.to >= following.from }
    overlapping_pair&.first
  end
end
