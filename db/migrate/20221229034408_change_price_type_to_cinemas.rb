class ChangePriceTypeToCinemas < ActiveRecord::Migration[6.1]
  def change
    change_column :cinemas, :regular_price, :integer, default: 0
    change_column :cinemas, :concession_price, :integer, default: 0
    change_column :cinemas, :elderly_price, :integer, default: 0
    change_column :cinemas, :disability_price, :integer, default: 0
  end
end
