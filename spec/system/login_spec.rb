# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Session Management' do
  let(:user) { FactoryBot.create :user }

  it 'shows the login screen' do
    visit clients_path
    expect(page).to have_button('Sign in')
  end
end