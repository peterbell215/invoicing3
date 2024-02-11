# frozen_string_literal: true

# This model represents the default charge that is applied to a specific client over a specific period.
class Price < ApplicationRecord
  belongs_to :client

  monetize :hourly_charge_rate_pence

  # Checks if for the provided client_id any price entries' date ranges overlap.
  # @param [ActiveResult] prices
  # @return [PriceHistory]
  def self.overlap?(prices)
    return false if prices.length <= 1

    overlapping_pair = prices.each_cons(2).find { |previous, following| previous.to >= following.from }
    overlapping_pair&.first
  end
end
