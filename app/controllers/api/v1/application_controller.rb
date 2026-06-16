# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      private

      def current_user
        @current_user ||= begin
          token = request.headers["Authorization"]&.split&.last

          payload = JwtService.decode(token)

          User.find_by(id: payload[:user_id]) if payload
        end
      end

      def authenticate_user!
        return if current_user

        render json: { error: "unauthorized" }, status: :unauthorized
      end
    end
  end
end
