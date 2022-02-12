class Store < ApplicationRecord
  belongs_to :partner

  has_many :follows
  has_many :users, through: :follows

  def to_s
    email
  end

  def total_following_store
    Follow.where(store_id: self.id).count
  end
end