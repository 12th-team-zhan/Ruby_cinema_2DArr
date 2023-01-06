class AddUseStatusDefaultToTickets < ActiveRecord::Migration[6.1]
  def change
    change_column :tickets, :use_status, :integer, default: 0
  end
end
