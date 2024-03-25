# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice do
  describe 'FactoryBot' do
    subject(:invoice) { create(:invoice, :client_with_sessions) }

    specify { expect(invoice.date).to eq Date.new(2024, 3, 16) }
    specify { expect(invoice.client_sessions.length).to eq 4 }
  end

  describe '::create' do
    context 'when it is a new invoice' do
      let(:invoice_params) { attributes_for(:invoice, client_id: client.id) }
      let(:client) { create(:client, :with_client_sessions) }

      it 'creates the invoice and associates all the client sessions' do
        client_session_ids = client.client_session_ids
        amount = Money.new(ClientSession.where(id: client_session_ids).sum(:current_rate_pence), 'GBP')

        invoice_params[:client_session_ids] = client_session_ids
        invoice_params[:amount] = amount

        invoice = Invoice.create(invoice_params)

        expect(invoice.client_sessions.pluck(:id)).to match client_session_ids
        expect(invoice.amount).to eq(amount)
      end

      it 'creates the invoice and associates some of the client sessions' do
        client_session_ids = client.client_session_ids
        first_client_session_id = client_session_ids.pop

        invoice_params[:client_session_ids] = client_session_ids
        invoice = Invoice.create(invoice_params)

        expect(invoice.client_sessions.pluck(:id)).to match client_session_ids
        expect(ClientSession.find(first_client_session_id).invoice_id).to be_nil
      end
    end
  end
end
