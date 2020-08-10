class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation).freeze
  validates :name, presence: true, length: {maximum: Settings.number.max_name}
  validates :email, presence: true,
      length: {maximum: Settings.number.max_email},
      format: {with: Settings.text.string_validate},
             uniqueness: {case_sensitive: false}
  validates :password, presence: true,
      length: {minimum: Settings.number.min_pass}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
