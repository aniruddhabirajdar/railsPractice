class User < ApplicationRecord
  has_many :orders
  has_many :posts
end
