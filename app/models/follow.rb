class Follow < ApplicationRecord
  # The user giving the follow
  # belongs_to :follower, foreign_key: :follower_id, class_name: "User"
  belongs_to :user 
  belongs_to :store

  # The store being followed
  # belongs_to :followed_store, foreign_key: :followed_store_id, class_name: "Store"
end

# 'has_many :followings, :through => :follows, :source => <name>'.