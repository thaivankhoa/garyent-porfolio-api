module RequestHelper
  def json_response
    @json_response ||= JSON.parse(response.body)
  end

  def auth_headers(user)
    @auth_headers ||= user.create_new_auth_token
  end

  def authenticated_header(user)
    auth_headers(user).merge('Accept' => 'application/json', 'Content-Type' => 'application/json')
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
  config.include RequestHelper, type: :controller
end 