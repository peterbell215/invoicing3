# frozen_string_literal: true

class ClientSerializer < Blueprinter::Base
  identifier :id

  fields :name, :address1, :address2, :town, :postcode, :email, :title, :current_rate_since
  association :current_rate, blueprint: MoneySerializer

  view :short do
    field :name
  end
end
