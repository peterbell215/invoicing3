# frozen_string_literal: true

class PriceSerializer < Blueprinter::Base
  identifier :id

  fields :client_id, :from, :to, :hourly_charge_rate
end
