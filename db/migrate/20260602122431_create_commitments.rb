class CreateCommitments < ActiveRecord::Migration[7.2]
  def change
    create_table :commitments, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.string :name, null: false
      t.integer :category, null: false

      t.decimal :amount, precision: 10, scale: 2, null: false
      t.decimal :interest_rate, precision: 5, scale: 2

      t.date :start_date, null: false
      t.integer :duration_months

      t.timestamps
    end
  end
end
