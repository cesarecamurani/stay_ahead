class AddPrecisionToUserMoneyFields < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :monthly_income, :decimal, precision: 10, scale: 2
    change_column :users, :savings, :decimal, precision: 10, scale: 2
  end
end
