class Meeting < ApplicationRecord
  belongs_to :client

  monetize :current_rate_pence
end
