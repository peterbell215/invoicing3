# frozen_string_literal: true

require 'rails_helper'

describe FeeSerializer do
  describe 'serialize standard object' do
    subject(:fee) { FactoryBot.create :fee, client: client }
    let(:client) { FactoryBot.create :client }

    it 'creates valid JSON' do
      json = FeeSerializer.render_as_hash(fee, root: :fee)

      expect(json).to match fee: { id: fee.id, client_id: client.id, from: Date.new(2022, 10, 1), to: nil,
                                   hourly_charge_rate: {amount:6000 , currency: "GBP" }
      }
    end
  end
end
