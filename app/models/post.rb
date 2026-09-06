class Post < ApplicationRecord
  belongs_to :user
  has_many :comentarios, dependent: :destroy

  validates :titulo, presence: true
end
