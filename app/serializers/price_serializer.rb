# frozen_string_literal: true

class PriceSerializer < ActiveModel::Serializer
  attributes :id, :from, :to, :hourly_charge_rate

  belongs_to :client
end
