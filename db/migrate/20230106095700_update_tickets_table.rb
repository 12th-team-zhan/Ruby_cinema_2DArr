class UpdateTicketsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :tickets, :seat
    add_column :tickets, :use_status, :integer
  end
end
