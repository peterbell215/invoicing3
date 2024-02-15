# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoreExtensions::Money::Dinero do
  subject { Money.new(6000) }

  specify { expect(subject.as_dinero).to match amount: 6000, currency: 'GBP' }
end
