# frozen_string_literal: true

require 'rails_helper'

describe InvoiceSerializer do
  subject(:json) { InvoiceSerializer.render_as_hash(invoice, root: :invoice) }
  let(:invoice) { FactoryBot.create :invoice }
  let(:client_as_json) { ClientSerializer.render_as_hash(invoice.client, view: :short_details) }

  context 'When it creates valid JSON' do
    specify { expect(json[:invoice].keys.sort).to match [:id, :amount, :date, :client, :client_sessions, :paid].sort }
    specify { expect(json[:invoice][:id]).to eq invoice.id }
    specify { expect(json[:invoice][:client]).to match client_as_json }

    it 'includes the individual sessions' do
      json[:invoice][:client_sessions].each do |client_session|
        expect(client_session[:current_rate]).to match amount: 6000, currency: 'GBP'
        expect(client_session[:duration]).to eq 60
      end
    end
  end
end