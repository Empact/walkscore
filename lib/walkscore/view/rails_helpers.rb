require 'walkscore/view/helpers'

module Walkscore
  module View
    module RailsHelpers
      include Walkscore::View::Helpers

      def walkscore_text_tag(walkscore)
        url = ws_url(walkscore)
        link_to(WALKSCORE_TRADE_MARK, url) + ": " + link_to(ws_score(walkscore), url)
      end

      def walkscore_logo_tag(walkscore)
        url = ws_url(walkscore)
        link_to(
          image_tag(Walkscore::Score::LOGO_URL, alt: WALKSCORE_TRADE_MARK),
          url
        ) + ": " + link_to(ws_score(walkscore), url)
      end
    end
  end
end
