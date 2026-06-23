class AddCurrencyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :currency, :string, null: false, default: "EUR"
  end
end
