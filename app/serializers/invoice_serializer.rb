# frozen_string_literal: true

# Provides ability to seralize to JSON details of an invoice.  Serialization includes the client with id and name.
class InvoiceSerializer < Blueprinter::Base
  identifier :id

  fields :date, :status

  association :client, blueprint: ClientSerializer, view: :short_details
  association :client_sessions, blueprint: ClientSessionSerializer, view: :short_details
  association :amount, blueprint: MoneySerializer
end
