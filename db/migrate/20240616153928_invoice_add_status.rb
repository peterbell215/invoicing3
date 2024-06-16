class InvoiceAddStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :status, :integer, default: 0, null: false
    remove_column :invoices, :paid
  end
end
