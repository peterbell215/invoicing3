# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Administration' do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  let(:client) { attributes_for(:client) }
  let(:client_without_town) { attributes_for(:client, town: nil) }

  it 'shows the Client page with New Button' do
    sign_in user
    visit clients_path

    expect(page).to have_content('Client List')
    expect(page).to have_button('New')
  end

  # rubocop:disable RSpec/NoExpectationExample - check done in #check_new_client
  scenario 'adding a new client', :js do
    sign_in admin_user
    visit new_client_path

    fill_in_new_client(client)

    click_on 'Submit'

    check_new_client(client)
  end
  # rubocop:enable RSpec/NoExpectationExample

  # rubocop:disable RSpec/NoExpectationExample - check done in #check_error_flag
  scenario 'missing a required field', :js do
    sign_in admin_user
    visit new_client_path

    fill_in_new_client(client_without_town)

    click_on 'Submit'

    check_error_flagged
  end
  # rubocop:enable RSpec/NoExpectationExample

  # rubocop:disable RSpec/NoExpectationExample - check done in #check_existing_client
  scenario 'editing an existing client', :js do
    client = create(:client)

    sign_in admin_user
    visit edit_client_path(client.id)

    fill_in('address1', with: "#{client.address1} modified")
    click_on 'Submit'

    check_existing_client(client, address1: "#{client.address1} modified")
  end
  # rubocop:enable RSpec/NoExpectationExample

  def fill_in_new_client(client)
    %w[name email address1 town postcode].each do |field|
      fill_in(field, with: client[field.to_sym])
    end
  end

  def check_new_client(client)
    expect(page.find('div .alert')).to have_content('Client created.')

    saved_client = Client.find_by(name: client[:name])
    expect(saved_client).to have_attributes(client)
  end

  def check_error_flagged
    expect(page.find('div[data-testid="town"] > div.invalid-feedback')).to have_content("can't be blank")
  end

  def check_existing_client(client, **changed_fields)
    saved_client = Client.find(client[:id])

    saved_client.attributes.each do |field, value|
      expect(value).to eq(changed_fields.key?(field) ? changed_fields[field] : client[field])
    end

    expect(page.find('div.alert.alert-dismissible.alert-info')).to have_content('Client was successfully updated.')
  end
end
