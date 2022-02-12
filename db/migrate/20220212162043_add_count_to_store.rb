class AddCountToStore < ActiveRecord::Migration[6.1]
  def change
    add_column :stores, :store_count, :integer, default: 0
  end
end