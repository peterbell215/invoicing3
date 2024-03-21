class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.date :date
      t.money :amount
      t.references :client, null: false, foreign_key: true
      t.boolean :paid, default: false

      t.timestamps
    end

    add_reference :client_sessions, :invoice, null: true, foreign_key: true
  end
end
