require "walkscore/version"
require "walkscore/errors"
require "walkscore/score"
require 'faraday'

module Walkscore
  BASE_URL = 'http://api.walkscore.com'

  class << self
    attr_accessor :api_key

    def http_client
      if !api_key || api_key.empty?
        raise ArgumentError, 'Please set your Walkscore.api_key before making requests'
      end
      @http_client ||= Faraday.new(BASE_URL)
    end
  end
end
