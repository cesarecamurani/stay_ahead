# frozen_string_literal: true

require "jwt"

class JwtService
  SECRET_KEY = Rails.application.secret_key_base.to_s
  ENCODING_ALGORITHM = "HS256"

  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i

      JWT.encode(payload, SECRET_KEY, ENCODING_ALGORITHM)
    end

    def decode(token)
      decoded = JWT.decode(
        token,
        SECRET_KEY,
        true,
        algorithm: ENCODING_ALGORITHM
      )[0]

      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError
      nil
    end
  end
end
