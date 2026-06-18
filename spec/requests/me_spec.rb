# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me", type: :request do
  include_context "authenticated request"
  include_context "shared variables"

  describe "GET /api/v1/me" do
    let(:user) { create(:user, monthly_income:, savings:) }

    context "when authenticated" do
      before { get "/api/v1/me", headers: headers }

      it "returns user id" do
        expect(json_response["user"]["id"]).to eq(user.id)
      end

      it "returns user email" do
        expect(json_response["user"]["email"]).to eq(user.email)
      end

      it "returns user monthly income" do
        expect(json_response["user"]["monthly_income"]).to eq("#{monthly_income}")
      end

      it "returns user savings" do
        expect(json_response["user"]["savings"]).to eq("#{savings}")
      end

      it "returns success status" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        get "/api/v1/me"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
