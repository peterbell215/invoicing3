# frozen_string_literal: true

require 'rails_helper'
require 'vite_rails'

RSpec.describe 'Client Session Administration' do
  let!(:admin_user) { create(:admin_user) }
  let!(:clients) { create_list(:client_with_random_name, 5, :with_client_sessions) }

  before do
    sign_in admin_user
    visit client_sessions_path
  end

  scenario 'show the Client Sessions Index page with all sessions listed', :js do
    expect(page.find('h1')).to have_content('Client Sessions List')
    expect(page).to have_css('tr', count: (5 * 4) + 1)

    clients.each do |client|
      client.client_sessions.each do |session|
        row = page.find("tr > td > a[href='#{Capybara.current_session.server_url}#{client_session_path(session)}']")
                  .find(:xpath, '../..')
        expect(row.find('td:nth-child(1)')).to have_content(client.name)
        expect(row.find('td:nth-child(2)')).to have_content(session.start.strftime('%-d %b %Y, %H:%M'))
        expect(row.find('td:nth-child(3)')).to have_content(session.duration)
        expect(row.find('td:nth-child(4)')).to have_content(session.current_rate.to_s)
        expect(row.find('td:nth-child(5) > button')).to have_content('Delete')
        expect(row.find('td:nth-child(5) > a')).to have_content('Edit')
      end
    end
  end
end
