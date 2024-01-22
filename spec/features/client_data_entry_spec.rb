# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Static content', type: :system do
  it 'shows the static text' do
    visit clients_path

    expect(page).to have_content('All Clients')
  end
end
