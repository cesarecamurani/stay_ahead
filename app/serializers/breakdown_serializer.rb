# frozen_string_literal: true

class BreakdownSerializer < BaseSerializer
  def serialize
    { breakdown: object.transform_values { |amount| money(amount) } }
  end
end
