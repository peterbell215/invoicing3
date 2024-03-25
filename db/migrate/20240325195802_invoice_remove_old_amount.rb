class InvoiceRemoveOldAmount < ActiveRecord::Migration[7.0]
  def change
    remove_column :invoices, :old_amount
  end
end
