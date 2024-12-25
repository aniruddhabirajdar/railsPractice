class Post < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :user
  has_many :categorizations
  has_many :categories, through: :categorizations
end
