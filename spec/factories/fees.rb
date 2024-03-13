# frozen_string_literal: true

FactoryBot.define do
  factory :fee do
    client
    from                { Date.new(2022, 10, 1) }
    hourly_charge_rate  { Money.new(6000, 'GBP')}
  end
end