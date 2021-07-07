class AddLikesCountToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :likes_count, :integer
  end
end
