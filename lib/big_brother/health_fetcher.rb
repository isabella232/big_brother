module BigBrother
  class HealthFetcher
    def self.current_health(address, port, path)
      url = "http://#{address}:#{port}#{path}"

      BigBrother.logger.debug("Fetching health from #{url}")
      response = EventMachine::HttpRequest.new(url).get
      response.response_header.status == 200 ? _parse_health(response) : 0
    end

    def self._parse_health(response)
      if response.response_header.has_key?('X_HEALTH')
        response.response_header['X_HEALTH'].to_i
      else
        response.response.slice(/Health: (\d+)/, 1).to_i
      end
    end
  end
end
