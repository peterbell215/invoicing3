class Meeting < ApplicationRecord
  belongs_to :client

  monetize :hourly_charge_pence
end
