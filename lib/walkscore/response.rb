module Walkscore
  class Response
    attr_accessor :score, :description, :updated, :logo_url,
      :more_info_icon, :more_info_link, :ws_link, :help_link,
      :snapped_lat, :snapped_lon

    def initialize(attributes)
      self.score       = attributes['walkscore'] # The Walk Score of the location.
      self.description = attributes['description'] # An English description of the Walk Score. E.G. Somewhat Walkable.
      self.updated     = attributes['updated'] # When the Walk Score was calculated.
      self.logo_url    = attributes['logo_url'] # Link to the Walk Score logo.
      self.more_info_icon = attributes['more_info_icon'] # Link to question mark icon to display next to the score.
      self.more_info_link = attributes['more_info_link'] # URL for the question mark to link to.
      self.ws_link     = attributes['ws_link'] # A link to the walkscore.com score and map for the point.
      self.help_link   = attributes['help_link'] # A link to the "How Walk Score Works" page.
      # All points are "snapped" to a grid (roughly 500 feet wide per grid cell).
      self.snapped_lat = attributes['snapped_lat'] # This value is the snapped latitude for the point.
      self.snapped_lon = attributes['snapped_lon'] # The snapped longitude for the point.
    end
  end
end
