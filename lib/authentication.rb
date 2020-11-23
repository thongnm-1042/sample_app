require "jwt"

class Authentication
  ALGORITHM = "HS256"

  class << self
    def encode payload
      JWT.encode(payload, ENV["AUTH_SECRET"], ALGORITHM)
    end

    def decode token
      JWT.decode(token, ENV["AUTH_SECRET"], true, {algorithm: ALGORITHM}).first
    end
  end
end
