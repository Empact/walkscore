require 'faraday'
require 'json'

module Walkscore
  class Client
    BASE_URL = 'http://api.walkscore.com'

    def initialize(api_key:)
      @connection = Faraday.new(BASE_URL)
      @api_key = api_key
    end

    def find(location)
      if response = make_connection(location)
        Response.new(response)
      end
    end

    def make_connection(location)
      response = @connection.get do |req|
        req.url '/score'
        req.headers['Accepts'] = 'application/json'
        req.params['format'] = 'json'
        req.params['lat'] = location[:lat]
        req.params['lon'] = location[:long]
        req.params['address'] = location[:address] if location[:address]
        req.params['wsapikey'] = @api_key
      end
      case response.status
      when 200
        json_body = JSON.parse(response.body)
        case json_body['status']
        when 1, 2
          json_body
        when 40
          raise InvalidApiKey.new(response)
        when 41
          raise DailyQuotaExceeded.new(response)
        else
          raise UnexpectedStatus.new(response)
        end
      when 403
        raise IpAddressBlocked.new(response)
      when 404
        raise InvalidLatLong.new(response)
      when 500..599
        raise InternalError.new(response)
      else
        raise UnexpectedResponseCode.new(response)
      end
    end
  end
end
