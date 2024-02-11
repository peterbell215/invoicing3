class RenameMeetingChargesToPrices < ActiveRecord::Migration[7.0]
  def change
    rename_table :meeting_charges, :prices
  end
end
