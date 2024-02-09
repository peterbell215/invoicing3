# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email     { 'test.user@example.com' }
    password  { 'password123' }

    factory :admin_user do
      role      { :admin }
    end
  end
end