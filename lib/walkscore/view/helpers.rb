require 'walkscore'

module Walkscore
  module View
    module Helpers
      WALKSCORE_TRADE_MARK = "Walk Score®"

      def walkscore_text_tag(walkscore)
        url = ws_url(walkscore)
        score = ws_score(walkscore)
        %{<a href="#{url}">#{WALKSCORE_TRADE_MARK}</a>: <a href="#{url}">#{score}</a>}
      end

      def walkscore_logo_tag(walkscore)
        url = ws_url(walkscore)
        score = ws_score(walkscore)
        %{<a href="#{url}"><img src="#{Walkscore::Score::LOGO_URL}" alt="#{WALKSCORE_TRADE_MARK}"></a>: <a href="#{url}">#{score}</a>}
      end

      private

      def ws_score(walkscore)
        if walkscore.respond_to?(:score)
          walkscore.score
        else
          walkscore.fetch('walkscore')
        end
      end

      def ws_url(walkscore)
        if Walkscore.premium
          if walkscore.respond_to?(:ws_link)
            walkscore.ws_link
          else
            walkscore['ws_link']
          end
        end || Walkscore::Score::HELP_LINK
      end
    end
  end
end
