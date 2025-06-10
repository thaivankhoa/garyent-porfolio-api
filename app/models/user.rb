class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :registerable
  #  :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :portfolios, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  def password_required?
    return false if persisted? && password.nil? && password_confirmation.nil?
    true
  end
end
