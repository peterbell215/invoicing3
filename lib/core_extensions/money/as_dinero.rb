# frozen_string_literal: true

module CoreExtensions
  module Money
    # This module adds ability to generate a hash that is consistent with the Javascript library Dinero.
    module Dinero
      def as_dinero
        { amount: fractional, currency: currency.iso_code }
      end
    end
  end
end

Money.include CoreExtensions::Money::Dinero
