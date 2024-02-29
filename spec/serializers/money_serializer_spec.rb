# frozen_string_literal: true

require 'rails_helper'

describe MoneySerializer do
  describe 'serialize standard object' do
    let(:money) { Money.new(6000, 'GBP') }

    it 'creates valid JSON' do
      json = MoneySerializer.render_as_hash(money, root: :money)

      expect(json).to match money: { amount: 6000, currency: 'GBP' }
    end
  end
end
