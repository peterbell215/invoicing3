# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    name      { 'Test Client' }
    email     { 'test.client@test.com' }
    address1  { 'The Test Avenue' }
    town      { 'Cambridge' }
    postcode  { 'CB99 1TA' }

    trait :client_with_fees do
      transient do
        gap { 1.day }
      end

      fees {
        3.times.each_with_object([]) do |loop, fees_array|
          from = fees_array.empty? ? Date.new(2022, 12, 1) : fees_array.last.to + gap
          to = loop < 2 ? from + 6.months : nil
          fees_array.push(association(:fee, from: from, to: to))
        end
      }
    end
  end
end