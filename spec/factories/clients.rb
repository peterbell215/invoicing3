# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    name      { 'Test Client' }
    email     { 'test.client@test.com' }
    address1  { 'The Test Avenue' }
    town      { 'Cambridge' }
    postcode  { 'CB99 1TA' }

    factory :client_with_prices do
      transient do
        gap { 1.day }
      end

      prices {
        3.times.each_with_object([]) do |loop, prices_array|
          from = prices_array.empty? ? Date.new(2022, 12, 1) : prices_array.last.to + gap
          to = loop < 2 ? from + 6.months : nil
          prices_array.push(association(:price, from: from, to: to))
        end
      }
    end
  end
end