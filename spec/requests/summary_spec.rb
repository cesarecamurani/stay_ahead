# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Summary", type: :request do
  include_context "authenticated request"
  include_context "shared config"

  describe "GET /api/v1/summary" do
    let(:user) { create(:user) }
    let(:commitment_amount) { 20 }
    let!(:commitment) do
      create(
        :commitment,
        user:,
        amount: commitment_amount,
        recurrence: :monthly
      )
    end
    let(:monthly_income) { user.monthly_income.to_s }
    let(:savings) { user.savings.to_s }
    let(:available_cash_flow) { (user.monthly_income - commitment_amount).to_s }
    let(:monthly_commitments_amount) { "20.0" }

    let(:summary_data) do
      {
        summary: {
          monthly_income:,
          savings:,
          available_cash_flow:,
          monthly_commitments_amount:
        }
      }
    end

    context "when user is authenticated" do
      before { get "/api/v1/summary", headers: auth_headers }

      it "returns 200 status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns summary data" do
        expect(json_response).to eq(summary_data)
      end
    end

    context "when user is not authenticated" do
      before { get "/api/v1/summary", headers: {} }

      it "returns 401 unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
