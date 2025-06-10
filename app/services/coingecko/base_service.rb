require 'uri'
require 'net/http'
require 'json'

module Coingecko
  class BaseService
    BASE_URL = ENV.fetch('COINGECKO_API_URL').freeze
    API_KEY = ENV.fetch('COINGECKO_API_KEY').freeze

    class Error < StandardError; end
    class RateLimitError < Error; end
    class ApiError < Error; end
    class ConnectionError < Error; end

    private

    def get(path, params = {})
      make_request(path, params)
    end

    def make_request(path, params)
      url = build_url(path, params)
      http = setup_http(url)
      request = build_request(url)

      response = http.request(request)
      handle_response(response)
    rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, Errno::ECONNREFUSED => e
      raise ConnectionError, "Connection failed: #{e.message}"
    rescue StandardError => e
      raise Error, "Unexpected error: #{e.message}"
    end

    def build_url(path, params = {})
      uri = URI.join(BASE_URL, path)
      uri.query = URI.encode_www_form(params) if params.any?
      uri
    end

    def setup_http(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.read_timeout = 10
      http.open_timeout = 10
      http
    end

    def build_request(url)
      request = Net::HTTP::Get.new(url)
      request['accept'] = 'application/json'
      request['x-cg-api-key'] = API_KEY
      request
    end

    def handle_response(response)
      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 429
        raise RateLimitError, 'Rate limit exceeded'
      when 400..499
        raise ApiError, "Client error: #{response.body}"
      when 500..599
        raise ApiError, "Server error: #{response.body}"
      else
        raise Error, "Unknown error: #{response.body}"
      end
    end
  end
end 