# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Administration' do
  let(:user) { FactoryBot::create :user }
  let(:admin_user) { FactoryBot::create :admin_user }

  let(:client) { FactoryBot.attributes_for :client }

  it 'shows the Client page with New Button' do
    sign_in user
    visit clients_path

    expect(page).to have_content('All Clients')
    expect(page).to have_button('New')
  end

  scenario 'adding a new user', js: true do
    sign_in admin_user
    visit new_client_path

    fill_in_new_client(client)

    click_button 'Submit'

    expect(page.find('div .alert')).to have_content('Client created.')

    saved_client = Client.find_by(name: client[:name])
    expect(saved_client).to have_attributes(client)
  end

  def fill_in_new_client(client)
    %w[name email address1 town postcode].each do |field|
      fill_in(field, with: client[field.to_sym])
    end
  end

  def check_new_client(model, client)

  end
  def check_new_client
    new_client = Client.find_by(name:'Test Client')
  end
end
