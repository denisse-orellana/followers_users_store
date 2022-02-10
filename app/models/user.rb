class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # # returns an array of follows a user gave to someone else
  # has_many :given_follows, foreign_key: :follower_id, class_name: "Follow"
  
  # # returns an array of other users who the user has followed
  # has_many :followings, through: :given_follows, source: :followed_store

  has_many :follows
  has_many :followers, through: :follows
end


# class User < ApplicationRecord

#   has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
#   has_many :followees, through: :followed_users

#   has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
#   has_many :followers, through: :following_users

# end