class ChangeDefaultCurrencyToGbp < ActiveRecord::Migration[7.0]
  def change
    change_column_default :session_charges, :hourly_charge_rate_currency, 'GBP'
    rename_column :sessions, :charge_currency, :current_rate_currency
    change_column_default :sessions, :current_rate_currency, 'GBP'
  end
end
