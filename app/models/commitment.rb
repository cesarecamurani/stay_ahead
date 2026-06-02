class Commitment < ApplicationRecord
  belongs_to :user

  enum category: {
    obligation: 0,   # rent, mortgage, essential fixed costs
    debt: 1,         # loans, installments, credit repayments
    service: 2,      # subscriptions, insurance (for now)
    investment: 3    # pension, funds, investing flows
  }

  validates :name, presence: true
  validates :category, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
end
