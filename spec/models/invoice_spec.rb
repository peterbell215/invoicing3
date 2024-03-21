require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'FactoryBot' do
    subject(:invoice) { create :invoice }

    specify { expect(invoice.date).to eq Date.new(2024, 3, 16) }
    specify { expect(invoice.client_sessions.length).to eq 4 }
  end

end
