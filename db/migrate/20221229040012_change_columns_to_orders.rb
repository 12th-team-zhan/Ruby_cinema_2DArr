class ChangeColumnsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column(:orders, :movie_name, :string)
    add_column(:orders, :theater_name, :string)
    add_column(:orders, :cinema_name, :string)
    add_column(:orders, :regular_quantity, :integer, default: 0)
    add_column(:orders, :concession_quantity, :integer, default: 0)
    add_column(:orders, :elderly_quantity, :integer, default: 0)
    add_column(:orders, :disability_quantity, :integer, default: 0)

    remove_column(:orders, :payment_method)
  end
end
