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
      Response.new(find_json(location))
    end

    def find_json(location)
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
          raise InvalidApiKey.new(response.body)
        when 41
          raise DailyQuotaExceeded.new(response.body)
        else
          raise UnexpectedStatus.new(response.body)
        end
      when 403
        raise IpAddressBlocked.new(response.body)
      when 404
        raise InvalidLatLong.new(response.body)
      when 500..599
        raise InternalError.new(response.body)
      else
        raise UnexpectedResponseCode.new(response.body)
      end
    end
  end
end
