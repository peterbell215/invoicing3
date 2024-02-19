# frozen_string_literal: true

require 'rails_helper'

describe 'Client' do
  describe 'FactoryBot' do
    subject(:test_client) { build(:client) }

    it 'creates a sample item correctly' do
      expect(test_client.name).to eq('Test Client')
    end
  end

  describe 'validations' do
    %i[name email address1 town postcode].each do |field|
      it "flags an empty #{field}" do
        test_client = build(:client, field => nil)
        expect(test_client).not_to be_valid
      end
    end

    example_group 'postcode' do
      specify { expect(build(:client, postcode: 'CB1 1TT')).to be_valid }
      specify { expect(build(:client, postcode: 'cb1 1tt')).to be_valid }
      specify { expect(build(:client, postcode: 'cb999 111')).not_to be_valid }
    end
  end

  describe '#current_rate' do
    context 'when a new record is built with a nil value for hourly_charge' do
      subject(:test_client) { build(:client) }

      it 'autofills the price.' do
        expect(test_client.current_rate).to eq Money.new(6000)
      end
    end

    context 'when a new record is created with a nil value for hourly_charge' do
      before { create(:client) }

      let(:read_back_client) { Client.find_by(name: 'Test Client') }

      it 'creates a child record price with a default value' do
        expect(read_back_client.current_rate).to eq Money.new(6000)
      end
    end
  end

  describe '#current_rate_since' do
    before { travel_to(Date.new(2024, 2, 1)) }

    context 'when a new record is built with a nil value for hourly_charge' do
      subject(:test_client) { build(:client) }

      it 'autofills the price.' do
        expect(test_client.current_rate_since).to eq Time.zone.today
      end
    end
  end

  describe '#current_rate=' do
    context 'when a new client record is built with current_rate set' do
      subject(:test_client) { Client.new(current_rate: Money.new(7000)) }

      it 'creates a corresponding Price child' do
        expect(test_client.current_rate).to eq Money.new(7000)
      end
    end

    context 'when a new client record is created with current_rate set' do
      before { Client.create!(attributes_for(:client).merge(current_rate: Money.new(7000))) }

      let(:read_back_client) { Client.find_by(name: 'Test Client') }

      it 'creates a corresponding Price child' do
        expect(read_back_client.current_rate).to eq Money.new(7000)
      end
    end

    context 'when the same current_rate is set a 2nd time' do
      subject(:test_client) { Client.create!(attributes_for(:client).merge(current_rate: Money.new(7000))) }

      it 'does not do an update to the current Price record' do
        test_client.current_rate = Money.new(7000)
        expect(test_client.current_price).not_to be_hourly_charge_rate_pence_changed
      end
    end
  end

  describe 'ensure no overlaps on Price' do
    context 'when non-overlapping Prices exist' do
      subject(:test_client) { build(:client_with_prices) }

      it 'passes validation' do
        expect(test_client).to be_valid
      end
    end

    context 'when overlapping Prices exist' do
      subject(:test_client) { build(:client_with_prices, gap: -5.days) }

      it 'fails validation' do
        expect(test_client).not_to be_valid
        expect(test_client.errors[:prices].first).to eq 'price to 2023-06-01 overlaps with its successor'
      end
    end
  end
end
