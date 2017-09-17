class Post < ApplicationRecord
  validates :content, length: { maximum: 140 }, presence: true
end
