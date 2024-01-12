# frozen_string_literal: true

# This model represents the default charge that is applied to a specific client over a specific period.
class SessionCharge < ApplicationRecord
  belongs_to :client

  monetize :hourly_charge_rate_pence

  # Checks if for the provided client_id any session charge entries' date ranges overlap.
  # @param [ActiveResult] session_charges
  # @return [SessionCharge]
  def self.overlap?(session_charges)
    return false if session_charges.length <= 1

    overlapping_pair = session_charges.each_cons(2).find { |previous, following| previous.to >= following.from }
    overlapping_pair&.first
  end
end
