# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  include_context "authenticated request"
  include_context "shared variables"

  describe "POST /api/v1/users" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          email:,
          password:,
          password_confirmation:,
          monthly_income:,
          savings:
        }
      end

      before { post "/api/v1/users", params: { user: valid_attributes }, headers: }

      it "returns created status" do
        expect(response).to have_http_status(:created)
      end

      it "returns a token" do
        expect(json_response["token"]).to be_present
      end

      it "returns user email" do
        expect(json_response["user"]["email"]).to eq(email)
      end

      it "returns user id" do
        expect(json_response["user"]["id"]).to be_present
      end

      it "returns registered message" do
        expect(json_response["message"]).to eq("registered")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          email:,
          password:,
          password_confirmation: "different_password"
        }
      end

      subject(:do_request) { post "/api/v1/users", params: { user: invalid_attributes } }

      it "does not create a user" do
        expect { do_request }.not_to change(User, :count)
      end

      it "returns unprocessable_entity status" do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        do_request
        expect(json_response["errors"]).to eq(["Password confirmation doesn't match Password"])
      end
    end
  end
end
