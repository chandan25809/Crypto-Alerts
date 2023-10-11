class User < ApplicationRecord
    has_many :alerts
    has_secure_password

    validates :user_name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
    validates :status, inclusion: { in: %w(active inactive) }

end
