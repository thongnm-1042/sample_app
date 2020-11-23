module API
  class Base < Grape::API
    error_formatter :json, API::ErrorFormatter

    mount API::V1::Base
    # mount API::V2::Base (next version)
  end
end
