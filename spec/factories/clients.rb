# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    name      { 'Test Client' }
    email     { 'test.client@test.com' }
    address1  { 'The Test Avenue' }
    town      { 'Cambridge' }
    postcode  { 'CB99 1TA' }

    factory :client_with_meeting_charges do
      transient do
        gap { 1.day }
      end

      meeting_charges {
        3.times.each_with_object([]) do |loop, meeting_charges_array|
          from = meeting_charges_array.empty? ? Date.new(2022, 12, 1) : meeting_charges_array.last.to + gap
          to = loop < 2 ? from + 6.months : nil
          meeting_charges_array.push(association(:meeting_charge, from: from, to: to))
        end
      }
    end
  end
end