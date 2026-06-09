# frozen_string_literal: true

class Commitment < ApplicationRecord
  belongs_to :user

  enum category: {
    obligation: 0,   # rent, mortgage, essential fixed costs
    debt: 1,         # loans, installments, credit repayments
    service: 2,      # subscriptions, insurance (for now)
    investment: 3    # pension, funds, investing flows
  }

  enum status: {
    active: 0,
    inactive: 1
  }

  validates :name, presence: true, null: false
  validates :category, presence: true, null: false
  validates :status, presence: true, null: false
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :duration_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :amount, presence: true, numericality: { greater_than: 0 }, null: false
  validates :start_date, presence: true, null: false
end
