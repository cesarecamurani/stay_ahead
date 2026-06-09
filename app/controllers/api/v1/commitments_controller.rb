# frozen_string_literal: true

module Api
  module V1
    class CommitmentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_commitment, only: %i[ show update ]

      def index
        render json: current_user.commitments
      end

      def show
        render json: @commitment
      end

      def create
        commitment = current_user.commitments.build(
          commitment_params.merge(status: :active)
        )

        if commitment.save
          render json: commitment, status: :created
        else
          render json: { errors: commitment.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        commitment = current_user.commitments.find(params[:id])

        if commitment.update(commitment_params)
          render json: commitment, status: :ok
        else
          render json: { errors: commitment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_commitment
        @commitment = current_user.commitments.find(params[:id])
      end

      def commitment_params
        params.require(:commitment).permit(
          :name,
          :category,
          :status,
          :amount,
          :start_date,
          :duration_months,
          :interest_rate
        )
      end
    end
  end
end
