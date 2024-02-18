
class MoneySerializer < Blueprinter::Base
  field(:currency) { |object, options| object.currency.iso_code }
  field :fractional, name: :amount
end