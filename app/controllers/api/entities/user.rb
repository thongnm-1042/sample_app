module API
  module Entities
    class User < Grape::Entity
      expose :name
      expose :email
    end
  end
end
