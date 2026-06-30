# frozen_string_literal: true

module Api
  module V1
    class BreakdownController < ApplicationController
      before_action :authenticate_user!

      def show
        present_json(breakdown, serializer: BreakdownSerializer)
      end

      private

      def breakdown
        @breakdown ||= Calculator::Breakdown.new(current_user).call
      end
    end
  end
end
