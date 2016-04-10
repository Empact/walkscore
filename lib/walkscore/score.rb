require 'json'

module Walkscore
  class Score
    attr_reader :status, :score, :description, :updated,
      :logo_url, :more_info_icon, :more_info_link, :ws_link, :help_link,
      :snapped_lat, :snapped_lon

    def self.find(location)
      new(find_json(location))
    end

    def self.find_json(location)
      response = Walkscore.http_client.get do |req|
        req.url '/score'
        req.headers['Accepts'] = 'application/json'
        req.params['format'] = 'json'
        req.params['wsapikey'] = Walkscore.api_key
        req.params['lat'] = location[:lat]
        req.params['lon'] = location[:long]
        req.params['address'] = location[:address] if location[:address]
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

    def initialize(values)
      @status = values['status'] # Status code of the result https://www.walkscore.com/professional/api.php#handling
      @score = values['walkscore'] # The Walk Score of the location.
      @description = values['description'] # An English description of the Walk Score. E.G. Somewhat Walkable.
      @updated = values['updated'] # When the Walk Score was calculated.
      @logo_url = values['logo_url'] # Link to the Walk Score logo.
      @more_info_icon = values['more_info_icon'] # Link to question mark icon to display next to the score.
      @more_info_link = values['more_info_link'] # URL for the question mark to link to.
      @ws_link = values['ws_link'] # A link to the walkscore.com score and map for the point.
      @help_link = values['help_link'] # A link to the "How Walk Score Works" page.
      # All points are "snapped" to a grid (roughly 500 feet wide per grid cell).
      @snapped_lat = values['snapped_lat']
      @snapped_lon = values['snapped_lon']
    end
  end
end
