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
      parsed_results = JSON.parse(make_connection(location))
      Response.new(parsed_results)
    end

    def make_connection(location)
      response = @connection.get do |req|
        req.url '/score'
        req.headers['Accepts'] = 'application/json'
        req.params['format'] = 'json'
        req.params['lat'] = location[:lat]
        req.params['lon'] = location[:long]
        req.params['wsapikey'] = @api_key
      end
      response.body
    end
  end
end
