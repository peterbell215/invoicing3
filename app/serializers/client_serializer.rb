# frozen_string_literal: true

class ClientSerializer < Blueprinter::Base
  identifier :id

  field :name

  # Used to provide info for dropdowns, etc.
  view :short_details do
    association :current_rate, blueprint: MoneySerializer
  end

  view :full_details do
    fields :address1, :address2, :town, :postcode, :email, :title, :current_rate_since
    association :current_rate, blueprint: MoneySerializer
  end
end
