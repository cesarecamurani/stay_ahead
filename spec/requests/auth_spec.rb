# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user, password: "password123") }
  let(:json_response) { JSON.parse(response.body) }

  describe "POST /api/v1/login" do
    before do
      post "/api/v1/login", params: { email: user.email, password: }
    end

    context "with valid credentials" do
      let(:password) { "password123" }

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the correct message" do
        expect(json_response["message"]).to eq("logged_in")
      end

      it "returns the correct user email" do
        expect(json_response["user"]["email"]).to eq(user.email)
      end

      it "returns a JWT token" do
        expect(json_response["token"]).not_to be_nil
      end
    end

    context "with invalid credentials" do
      let(:password) { "wrongpassword" }

      it "returns an unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an error message" do
        expect(json_response["error"]).to eq("invalid_credentials")
      end
    end
  end

  describe "POST /api/v1/logout" do
    before { delete "/api/v1/logout" }

    it "returns a successful response" do
      expect(response).to have_http_status(:ok)
    end

    it "returns a logged out message" do
      expect(json_response["message"]).to eq("logged_out")
    end
  end
end
