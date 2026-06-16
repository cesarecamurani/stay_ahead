# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :commitments, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  validates :monthly_income,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :savings,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
end
