# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Administration' do
  let(:user) { FactoryBot::create :user }

  it 'shows the static text' do
    sign_in user

    visit clients_path
    expect(page).to have_content('All Clients')
  end
end
