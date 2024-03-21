class Invoice < ApplicationRecord
  belongs_to :client
  has_many :client_sessions
end
