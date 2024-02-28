class RenamePriceToFee < ActiveRecord::Migration[7.0]
  def change
    rename_table :prices, :fees
  end
end
