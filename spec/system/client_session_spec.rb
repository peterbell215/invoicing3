# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Session Administration' do
  let!(:admin_user) { create(:admin_user) }
  let!(:clients) { create_list(:client_with_random_name, 5, :with_client_sessions) }

  scenario 'show the Client page with the correct detail', :js do
    sign_in admin_user
    visit client_sessions_path

    expect(page.find('h1')).to have_content('Client Sessions List')

    expect(page).to have_selector('tr', count: 5*4 + 1)
  end
end