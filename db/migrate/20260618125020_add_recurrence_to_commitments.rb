class AddRecurrenceToCommitments < ActiveRecord::Migration[8.0]
  def change
    if table_exists?(:commitments) && !column_exists?(:commitments, :recurrence)
      add_column :commitments, :recurrence, :integer
    end
  end
end
