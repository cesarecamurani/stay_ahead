class AddRecurrenceToCommitments < ActiveRecord::Migration[8.0]
  def change
    add_column :commitments, :recurrence, :integer, null: false, default: 0
  end
end
