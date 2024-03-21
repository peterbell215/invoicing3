FactoryBot.define do
  factory :invoice do
    date            { Date.new(2024, 3, 16) }
    client          { create :client, :with_client_sessions }

    client_sessions { client.client_sessions }
  end
end
