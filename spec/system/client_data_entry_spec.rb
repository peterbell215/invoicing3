# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Administration' do
  let(:user) { FactoryBot::create :user }
  let(:admin_user) { FactoryBot::create :admin_user }

  let(:client) { FactoryBot.attributes_for :client }
  let(:client_without_town) { FactoryBot.attributes_for :client, town: nil }
  it 'shows the Client page with New Button' do
    sign_in user
    visit clients_path

    expect(page).to have_content('Client List')
    expect(page).to have_button('New')
  end

  scenario 'adding a new user', js: true do
    sign_in admin_user
    visit new_client_path

    fill_in_new_client(client)

    click_button 'Submit'

    check_new_client(client)
  end

  scenario 'missing a required field', js: true do
    sign_in admin_user
    visit new_client_path

    fill_in_new_client(client_without_town)

    click_button 'Submit'

    check_error_flagged
  end

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
end
