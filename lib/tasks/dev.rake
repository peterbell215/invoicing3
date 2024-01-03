# frozen_string_literal: true

namespace :dev do
  desc 'Creates a set of test data using Faker'
  task create_test_data: :environment do
    Faker::Config.locale = 'en-GB'

    Client.destroy_all

    10.times do
      postcode = "CB#{Random.rand(1..20)} #{Random.rand(1..20)}#{(0..1).map { rand(65..(65 + 26)).chr }.join}"
      charge = 10.0 * Random.rand(4..6)

      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      name = "#{first_name} #{last_name}"
      email = "#{first_name}.#{last_name}@users.com"
      client = Client.create!(name: name, email: email, address1: Faker::Address.street_address, town: 'Cambridge',
                              postcode: postcode)
    end
  end
end
