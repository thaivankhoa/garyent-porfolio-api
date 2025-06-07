module Api
  module V1
    module Auth
      class BaseController < Api::V1::BaseController
        include DeviseTokenAuth::Concerns::SetUserByToken
        before_action :authenticate_user!
      end
    end
  end
end 