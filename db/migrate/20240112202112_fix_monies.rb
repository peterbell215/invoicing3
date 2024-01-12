class FixMonies < ActiveRecord::Migration[7.0]
  def change
    rename_column :session_charges, :hourly_charge_rate_cents, :hourly_charge_rate_pence
    rename_column :sessions, :charge_cents, :current_rate_pence
  end
end
