# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'
require 'vite_rails'

RSpec.describe 'Client Administration' do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  let(:existing_client) { create(:client) }
  let(:client) { attributes_for(:client) }
  let(:client_without_town) { attributes_for(:client, town: nil) }

  scenario 'show the Client page with the correct detail', :js do
    sign_in admin_user
    visit client_path(existing_client)

    expect(page.find('h5')).to have_content('Client Details')

    %w[name email address1 town postcode].each do |field|
      expect(page).to have_field(field, with: existing_client[field], disabled: true)
    end

    expect(page).to have_field('current_rate', with: '60', disabled: true)
    expect(page).to have_field('current_rate_since', with: Date.today.to_fs(:rfc822), disabled: true)
  end

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

  # rubocop:disable RSpec/NoExpectationExample - check done in #check_new_fee_record_created
  scenario 'change pricing for an existing client', :js do
    client = Client.create(attributes_for(:client))

    sign_in admin_user
    visit edit_client_path(client.id)

    new_rate_from = (Date.today + 2.days)
    new_rate = client.current_rate + Money.new(1000)

    fill_in('new_rate_from', with: new_rate_from.strftime('%d/%m/%Y'))
    fill_in('new_rate', with: new_rate.amount)

    click_on 'Submit'

    check_new_fee_record_created(client, new_rate, new_rate_from)
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
    message_div = page.find('div.alert.alert-dismissible.alert-info')
    expect(message_div).to have_content('Client was successfully updated.')

    updated_client = Client.find(client[:id])

    updated_client.attributes.except('created_at', 'updated_at').each do |field, value|
      expect(value).to eq(changed_fields.key?(field.to_sym) ? changed_fields[field.to_sym] : client[field])
    end
  end

  def check_new_fee_record_created(client, new_rate, new_rate_from)
    message_div = page.find('div.alert.alert-dismissible.alert-info')
    expect(message_div).to have_content('Client was successfully updated.')

    updated_client = Client.find(client[:id])

    expect(updated_client.fees.count).to eq(2)
    expect(updated_client.current_rate).to eq(Money.new(7000, 'GBP'))
    expect(updated_client.current_rate_since).to eq(Date.today + 2.days)
  end
end
