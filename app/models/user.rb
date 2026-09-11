class User < ApplicationRecord
    has_secure_password
    has_many :posts, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :name, presence: true
end
