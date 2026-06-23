# frozen_string_literal: true

RSpec.shared_context "shared variables" do
  let(:json_response) { JSON.parse(response.body) }
  let(:email) { "user@example.com" }
  let(:password) { "password123" }
  let(:password_confirmation) { "password123" }
  let(:monthly_income) { 5000.0 }
  let(:savings) { 10000.0 }
  let(:currency) { "EUR" }
end
