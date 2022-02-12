class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :follows
  has_many :stores, through: :follows

  def to_s
    email
  end

  def total_followers_users
    Follow.where(user_id: self.id).count
  end
end





