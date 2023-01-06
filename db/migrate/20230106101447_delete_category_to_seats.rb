class DeleteCategoryToSeats < ActiveRecord::Migration[6.1]
  def change
    remove_column :seats, :category

    add_column :seats, :deleted_at, :datetime
    add_index :seats, :deleted_at
  end
end
