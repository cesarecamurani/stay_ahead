# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Commitments", type: :request do
  include_context "authenticated request"
  include_context "shared variables"

  describe "GET /api/v1/commitments" do
    let!(:first_commitment) { create(:commitment, user:, name: "Rent") }
    let!(:second_commitment) { create(:commitment, user:, name: "Insurance") }
    let!(:other_user_commitment) { create(:commitment) }

    context "when authenticated" do
      before { get "/api/v1/commitments", headers: }

      it "returns success status" do
        expect(response).to have_http_status(:success)
      end

      it "returns only current user commitments" do
        expect(json_response.size).to eq(2)
      end

      it "includes first commitment id" do
        expect(json_response.map { |item| item["id"] }).to include(first_commitment.id)
      end

      it "does not include other user commitments" do
        expect(json_response.map { |item| item["id"] }).not_to include(other_user_commitment.id)
      end
    end

    context "when not authenticated" do
      before { get "/api/v1/commitments" }

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error" do
        expect(json_response["error"]).to eq("unauthorized")
      end
    end
  end

  describe "GET /api/v1/commitments/:id" do
    let!(:commitment) { create(:commitment, user:, name: "Mortgage") }

    context "when authenticated and commitment belongs to current user" do
      before { get "/api/v1/commitments/#{commitment.id}", headers: }

      it "returns success status" do
        expect(response).to have_http_status(:success)
      end

      it "returns commitment id" do
        expect(json_response["id"]).to eq(commitment.id)
      end

      it "returns commitment name" do
        expect(json_response["name"]).to eq("Mortgage")
      end
    end

    context "when authenticated and commitment belongs to another user" do
      let(:other_commitment) { create(:commitment) }

      before { get "/api/v1/commitments/#{other_commitment.id}", headers: }

      it "returns not found status" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not authenticated" do
      before { get "/api/v1/commitments/#{commitment.id}" }

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error" do
        expect(json_response["error"]).to eq("unauthorized")
      end
    end
  end

  describe "POST /api/v1/commitments" do
    let(:valid_params) do
      {
        name: "Car Loan",
        category: "debt",
        amount: 300.25,
        start_date: Date.current,
        duration_months: 24,
        interest_rate: 4.5,
        recurrence: "monthly",
        status: "inactive"
      }
    end

    context "when authenticated with valid params" do
      subject(:send_request) { post "/api/v1/commitments", params: { commitment: valid_params }, headers: }

      it "creates a commitment" do
        expect { send_request }.to change(Commitment, :count).by(1)
      end

      it "returns created status" do
        send_request
        expect(response).to have_http_status(:created)
      end

      it "returns created commitment name" do
        send_request
        expect(json_response["name"]).to eq("Car Loan")
      end

      it "stores commitment for current user" do
        send_request
        expect(Commitment.order(:created_at).last.user_id).to eq(user.id)
      end

      it "forces active status on create" do
        send_request
        expect(json_response["status"]).to eq("active")
      end
    end

    context "when authenticated with invalid params" do
      let(:invalid_params) do
        {
          name: nil,
          category: "debt",
          amount: 100,
          start_date: Date.current,
          recurrence: "monthly"
        }
      end

      before { post "/api/v1/commitments", params: { commitment: invalid_params }, headers: }

      it "does not create a commitment" do
        expect(Commitment.count).to eq(0)
      end

      it "returns unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        expect(json_response["errors"]).to include("Name can't be blank")
      end
    end

    context "when authenticated without commitment param" do
      before { post "/api/v1/commitments", params: {}, headers: }

      it "returns bad request status" do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when not authenticated" do
      before { post "/api/v1/commitments", params: { commitment: valid_params } }

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error" do
        expect(json_response["error"]).to eq("unauthorized")
      end
    end
  end

  describe "PATCH /api/v1/commitments/:id" do
    let!(:commitment) { create(:commitment, user:, name: "Old Name", amount: 500) }

    context "when authenticated with valid params" do
      let(:update_params) { { name: "New Name", amount: 450 } }

      before { patch "/api/v1/commitments/#{commitment.id}", params: { commitment: update_params }, headers: }

      it "returns ok status" do
        expect(response).to have_http_status(:ok)
      end

      it "updates commitment name" do
        expect(commitment.reload.name).to eq("New Name")
      end

      it "returns updated commitment name" do
        expect(json_response["name"]).to eq("New Name")
      end
    end

    context "when authenticated with invalid params" do
      let(:invalid_update_params) { { amount: -1 } }

      before { patch "/api/v1/commitments/#{commitment.id}", params: { commitment: invalid_update_params }, headers: }

      it "returns unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        expect(json_response["errors"]).to include("Amount must be greater than 0")
      end

      it "does not update commitment amount" do
        expect(commitment.reload.amount.to_f).to eq(500.0)
      end
    end

    context "when authenticated and commitment belongs to another user" do
      let(:other_commitment) { create(:commitment) }

      before do
        patch "/api/v1/commitments/#{other_commitment.id}",
              params: { commitment: { name: "Not Allowed" } },
              headers:
      end

      it "returns not found status" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not authenticated" do
      before do
        patch "/api/v1/commitments/#{commitment.id}", params: { commitment: { name: "Blocked" } }
      end

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error" do
        expect(json_response["error"]).to eq("unauthorized")
      end
    end
  end
end
