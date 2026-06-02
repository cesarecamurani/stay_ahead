class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest
      t.decimal :monthly_income
      t.decimal :savings

      t.timestamps
    end
  end
end
