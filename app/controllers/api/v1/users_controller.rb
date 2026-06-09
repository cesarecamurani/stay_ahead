# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: [:me]

      def create
        user = User.new(user_params)

        if user.save
          reset_session
          session[:user_id] = user.id

          render json: {
            message: "registered",
            user: {
            id: user.id,
            email: user.email
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def me
        render json: {
          id: current_user.id,
          email: current_user.email,
          monthly_income: current_user.monthly_income,
          savings: current_user.savings
        }
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :monthly_income,
          :savings
        )
      end
    end
  end
end
