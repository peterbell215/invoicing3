# frozen_string_literal: true

require 'rails_helper'

describe ClientSerializer do
  describe 'serialize standard object' do
    subject(:client) { build :client }

    it 'creates valid JSON' do
      json = ClientSerializer.render_as_hash(client, root: :client)

      # @todo change the date to a defined date
      expect(json).to match client: { id: nil,
                                      name: 'Test Client', email: 'test.client@test.com', title: nil,
                                      address1: 'The Test Avenue', address2: nil, postcode: 'CB99 1TA',
                                      town: 'Cambridge',
                                      current_rate_since: Date.today,
                                      current_rate: {amount: 6000, currency: "GBP"}
      }
    end
  end
end
