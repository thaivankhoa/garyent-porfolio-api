module Api
  module V1
    class BaseController < ActionController::API
      protected
      
      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end
    end
  end
end 
