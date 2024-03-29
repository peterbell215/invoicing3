# frozen_string_literal: true

class FeeSerializer < Blueprinter::Base
  identifier :id

  fields :client_id, :from, :to
  association :hourly_charge_rate, blueprint: MoneySerializer
end
