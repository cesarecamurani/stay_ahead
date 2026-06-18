# frozen_string_literal: true

require "jwt"

class JwtService
  ALGORITHM = "HS256"

  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload = payload.merge(exp: exp.to_i)

      JWT.encode(payload, secret_key, ALGORITHM)
    end

    def decode(token)
      return if token.blank?

      decoded = JWT.decode(
        token,
        secret_key,
        true,
        algorithm: ALGORITHM
      )[0]

      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError
      nil
    end

    private

    def secret_key
      ENV.fetch("JWT_SECRET")
    end
  end
end
