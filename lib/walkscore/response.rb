module Walkscore
  class Response
    attr_accessor :score, :description, :updated, :logo_url, :ws_link

    def initialize(attributes)
      self.score       = attributes['walkscore']
      self.description = attributes['description']
      self.updated     = attributes['updated']
      self.logo_url    = attributes['logo_url']
      self.ws_link     = attributes['ws_link']
    end
  end
end
