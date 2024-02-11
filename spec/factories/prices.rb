# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    client
    from    { Date.new(2022, 10, 1) }
  end
end