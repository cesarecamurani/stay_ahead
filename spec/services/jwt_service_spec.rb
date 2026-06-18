# frozen_string_literal: true

require "rails_helper"

RSpec.describe JwtService, type: :service do
  let(:user) { create(:user) }
  let(:payload) { { user_id: user.id } }
  let(:token) { JwtService.encode(payload) }

  describe ".encode" do
    it "returns a valid JWT token" do
      expect(token).to be_a(String)
    end
  end

  describe ".decode" do
    it "returns the decoded payload" do
      decoded_payload = JwtService.decode(token)

      expect(decoded_payload[:user_id]).to eq(user.id)
    end

    it "returns nil for an invalid token" do
      expect(JwtService.decode("invalid_token")).to be_nil
    end
  end
end
