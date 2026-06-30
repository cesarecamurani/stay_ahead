# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      private

      def current_user
        return @current_user if defined?(@current_user)

        token = request.headers["Authorization"]&.split&.last
        payload = JwtService.decode(token)

        @current_user = payload && User.find_by(id: payload[:user_id])
      end

      def authenticate_user!
        return if current_user

        render json: { error: "unauthorized" }, status: :unauthorized
      end

      def present_json(object, serializer:)
        render json: serializer.new(object).serialize, status: :ok
      end
    end
  end
end
