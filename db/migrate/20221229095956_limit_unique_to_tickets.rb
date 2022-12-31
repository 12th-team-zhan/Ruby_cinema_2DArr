class LimitUniqueToTickets < ActiveRecord::Migration[6.1]
  def change
    add_index :tickets, [:showtime_id, :row, :column], unique: true
  end
end
