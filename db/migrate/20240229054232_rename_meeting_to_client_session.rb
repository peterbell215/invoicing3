class RenameMeetingToClientSession < ActiveRecord::Migration[7.0]
  def change
    rename_table :meetings, :client_sessions
  end
end
