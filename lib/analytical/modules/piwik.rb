module Analytical
  module Modules
    class Piwik
      include Analytical::Modules::Base

      def initialize(options = {})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location location do
          data = <<-HTML
            <!-- Piwik -->
            <script type="text/javascript">
              var piwikUrl = document.location.protocol + "//{{url}}/";
              document.write(
                unescape("%3Cscript src='" + piwikUrl + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
            </script>
            <script type="text/javascript">
              try {
                var piwikTracker = Piwik.getTracker(piwikUrl + "piwik.php", '{{siteId}}');
                piwikTracker.trackPageView();
                piwikTracker.enableLinkTracking();
                window.piwikTracker = piwikTracker
              } catch( err ) {}
            </script>
            <noscript>
              <p><img src="//{{url}}/piwik.php?idsite={{siteId}}&amp;rec=1" style="border:0" alt="" /></p>
            </noscript>
            <!-- End Piwik -->
          HTML
          data.sub('{{url}}', options[:url]).sub '{{siteId}}', options[:id].to_s
        end
      end

      def track(*args)
        if args.first
          "window.piwikTracker.trackPageView(#{args.first});"
        else
          'window.piwikTracker.trackPageView();'
        end
      end

      def event(name, *args)
        data = args.first
        data = args.first[:value] if args.first && args.first.is_a?(Hash)
        data = data.to_s
        custom_event 'Event', name, data
      end

      def identify(id, *_args)
        "window.piwikTracker.setUserId('#{id}');"
      end

      def custom_event(category, action, opt_label = nil, opt_value = nil)
        if !opt_label.nil? && !opt_value.nil?
          "window.piwikTracker.trackEvent('#{category}', '#{action}', '#{opt_label}', '#{opt_value}');"
        elsif !opt_label.nil?
          "window.piwikTracker.trackEvent('#{category}', '#{action}', '#{opt_label}');"
        else
          "window.piwikTracker.trackEvent('#{category}', '#{action}');"
        end
      end

      def track_search(keyword, category = nil, resultsCount = nil)
        if !category.nil? && !resultsCount.nil?
          "window.piwikTracker.trackSiteSearch('#{keyword}', '#{category}', '#{resultsCount}');"
        elsif !category.nil?
          "window.piwikTracker.trackSiteSearch('#{keyword}', '#{category}');"
        else
          "window.piwikTracker.trackSiteSearch('#{keyword}');"
        end
      end

      def track_goal(id, customRevenue = nil)
        if !customRevenue.nil?
          "window.piwikTracker.trackGoal('#{id}', '#{customRevenue}');"
        else
          "window.piwikTracker.trackGoal('#{id}');"
        end
      end
    end
  end
end
