class AddStatusToCommitments < ActiveRecord::Migration[7.2]
  def change
    add_column :commitments, :status, :integer, null: false, default: 0
  end
end
