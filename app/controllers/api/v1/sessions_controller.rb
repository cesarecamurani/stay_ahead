# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          reset_session
          session[:user_id] = user.id

          render json: {
            message: "logged_in",
            user: {
              id: user.id,
              email: user.email
            }
          }, status: :ok
        else
          render json: { error: "invalid_credentials" }, status: :unauthorized
        end
      end

      def destroy
        reset_session

        render json: { message: "logged_out" }, status: :ok
      end
    end
  end
end
