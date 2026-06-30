# frozen_string_literal: true

class BaseSerializer
  def initialize(object)
    @object = object
  end

  private

  attr_reader :object

  def money(value)
    return if value.nil?

    format("%.2f", value)
  end

  def decimal(value, precision: 4)
    return if value.nil?

    value.round(precision).to_f
  end

  def serialize
    raise NotImplementedError, "#{self.class} must implement #serialize"
  end
end
