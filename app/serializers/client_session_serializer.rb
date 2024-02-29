# frozen_string_literal: true

# Provides ability to seralize to JSON details of a client session.  Serialization includes the client with id and name.
class ClientSessionSerializer < Blueprinter::Base
  identifier :id

  fields :start, :duration

  association :client, blueprint: ClientSerializer
  association :current_rate, blueprint: MoneySerializer
end
