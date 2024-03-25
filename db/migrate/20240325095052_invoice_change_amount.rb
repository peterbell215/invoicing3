class InvoiceChangeAmount < ActiveRecord::Migration[7.0]
  def up
    rename_column :invoices, :amount, :old_amount
    add_monetize :invoices, :amount

    Invoice.update_all('amount_pence=old_amount::money::numeric::float8*100')
    Invoice.update_all("amount_currency='GBP'::text")
  end

  def down
  end
end
