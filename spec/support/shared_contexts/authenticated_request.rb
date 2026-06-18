# frozen_string_literal: true

require "rails_helper"

RSpec.shared_context "authenticated request" do
  let(:user) { create(:user) }
  let(:token) { JwtService.encode(user_id: user.id) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end
end
