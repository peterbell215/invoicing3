class AddEmailAndTitleToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :email, :string
    add_index :clients, :email, unique: true
    add_column :clients, :title, :string
  end
end
