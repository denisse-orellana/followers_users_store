class Store < ApplicationRecord
  # # Will return an array of follows for the given user instance
  # has_many :received_follows, foreign_key: :followed_store_id, class_name: "Follow"

  # # Will return an array of users who follow the user instance
  # has_many :followers, through: :received_follows, source: :follower

  has_many :follows
  has_many :followings, through: :follows
end
