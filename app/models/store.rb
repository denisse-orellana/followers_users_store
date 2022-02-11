class Store < ApplicationRecord
  belongs_to :partner

  has_many :follows
  has_many :users, through: :follows

  def to_s
    email
  end
end
