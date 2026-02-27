require 'uri'

module Jekyll
  module TargetBlank
    class External
      alias_method :original_external?, :external?

      def external?(href)
        href = href.to_s if href.respond_to?(:to_s)
        original_external?(href)
      rescue URI::InvalidURIError
        false
      end
    end
  end
end
