# frozen_string_literal: true

module Api
  module V1
    class SummaryController < ApplicationController
      before_action :authenticate_user!

      def show
        present_json(summary, serializer: SummarySerializer)
      end

      private

      def summary
        @summary ||= Calculator::Summary.new(current_user).call
      end
    end
  end
end
