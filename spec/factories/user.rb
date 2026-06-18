# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    monthly_income { 4000.00 }
    savings { 1000.00 }
  end
end
