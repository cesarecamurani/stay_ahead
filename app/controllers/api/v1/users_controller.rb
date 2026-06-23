# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: %i[me update]

      def create
        user = User.new(user_params)

        if user.save
          token = JwtService.encode(user_id: user.id)

          render json: {
            message: "registered",
            token: token,
            user: user_json(user)
          }, status: :created
        else
          render json: { errors: user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if current_user.update(profile_params)
          render json: { user: user_json(current_user) }, status: :ok
        else
          render json: { errors: current_user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def me
        render json: { user: user_json(current_user) }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :monthly_income,
          :savings,
          :currency
        )
      end

      def profile_params
        params.require(:user).permit(
          :monthly_income,
          :savings,
          :currency
        )
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          monthly_income: user.monthly_income,
          savings: user.savings,
          currency: user.currency
        }
      end
    end
  end
end
