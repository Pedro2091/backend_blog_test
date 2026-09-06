class Comment < ApplicationRecord
  belongs_to :post
  validates :comentario, presence: true
end
