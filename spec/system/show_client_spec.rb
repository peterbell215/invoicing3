# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Administration' do
  let(:admin_user) { create(:admin_user) }
  let(:client) { create(:client) }

  scenario 'show the Client page with the correct detail', :js do
    sign_in admin_user
    visit client_path(client)

    expect(page.find('h5')).to have_content('Client Details')

    %w[name email address1 town postcode].each do |field|
      expect(page).to have_field(field, with: client[field], disabled: true)
    end

    expect(page).to have_field('current_rate', with: '£60.00', disabled: true)
    expect(page).to have_field('current_rate_since', with: Date.today.to_fs(:rfc822), disabled: true)
  end
end
