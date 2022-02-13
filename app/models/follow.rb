class Follow < ApplicationRecord
  belongs_to :user 
  belongs_to :store

  # def increase_store_count
  #   Store.find(self.store_id).increment(:store_count).save
  # end
 
  # def decrease_store_count
  #   Store.find(self.store_id).decrement(:store_count).save
  # end
end
