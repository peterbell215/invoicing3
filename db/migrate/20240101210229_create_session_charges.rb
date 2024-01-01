class CreateSessionCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :session_charges do |t|
      t.references :client, null: false, foreign_key: true
      t.date :from
      t.date :to
      t.monetize :hourly_charge_rate

      t.timestamps
    end
  end
end
