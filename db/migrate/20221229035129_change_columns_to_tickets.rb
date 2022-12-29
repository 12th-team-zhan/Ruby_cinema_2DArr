class ChangeColumnsToTickets < ActiveRecord::Migration[6.1]
  def change
    remove_column(:tickets, :seat_list)
    remove_column(:tickets, :category)
    remove_column(:tickets, :movie_name)
    remove_column(:tickets, :theater_name)
    remove_column(:tickets, :cinema_name)
    remove_column(:tickets, :regular_quantity)
    remove_column(:tickets, :concession_quantity)
    remove_column(:tickets, :elderly_quantity)
    remove_column(:tickets, :disability_quantity)

    add_belongs_to :tickets, :user
    add_column :tickets, :row, :integer
    add_column :tickets, :column, :integer
  end
end
