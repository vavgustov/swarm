module BotBrowser
  DOWNLOAD_ATTEMPTS = 5
  SUCCESS_CODES = [200, 304].freeze
  SLEEP_DURATION = 5

  class << self
    def download(url, js: true)
      DOWNLOAD_ATTEMPTS.times do
        response = js ? process_with_js(url) : process_without_js(url)
        status = SUCCESS_CODES.include?(response.try(:status)) || SUCCESS_CODES.include?(response.try(:status_code))
        unless status
          sleep SLEEP_DURATION
          next
        end
        return response.body
      end
      raise Swarm::SpiderDownloadFailure, url
    end

    private

    def process_with_js(url)
      browser = Capybara.current_session
      browser.visit url
      browser
    end

    def process_without_js(url)
      Faraday.get url
    end
  end
end
