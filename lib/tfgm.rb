##
## Dependencies (used for development and using this module independently)
##
['rubygems', 'curb', 'json', 'active_support/core_ext/object/to_query'].each { |_require| require _require }

##
## Some nice camel-cased error names. Gotta catch 'em all.
##
module TFGM_Error
  class Error < StandardError; end
  class InvalidDeveloperKey < Error; end
  class InvalidApplicationKey < Error; end
  class DeveloperOrApplicationKeyNotAccepted < Error; end
  class CarParkStateTypeInvalid < Error; end
end

##
## Let's get to work.
##
module TFGM

  ##
  ## TFGM::API represents external API calls.
  ##
  class API

    ## The endpoint we're calling, stored as a constant.
    TFGM_BASE_URL = "http://opendata.tfgm.com"

    ## The version
    TFGM_VERSION = "0.0.3"
    
    ##
    ## When we call TFGM::API.new, we automatically call initialize. Interesting.
    ##
    def initialize(dev_key, app_key)

      ## Developer key is needed.
      throw TFGM_Error::InvalidDeveloperKey if not dev_key.to_s.length == 36

      ## Oops, and an application key. They're tied.
      throw TFGM_Error::InvalidApplicationKey if not app_key.to_s.length == 36

      ## Move the keys to class-based variables
      @developer_key = dev_key
      @application_key = app_key

      ## This checks if the API keys is valid.
      _call('/api/enums')
    end

    ##
    ## Our central API beast.
    ##
    def _call(endpoint, params = {})
      ## Compile RESTful API address.
      _query = TFGM_BASE_URL + endpoint
      _query += "?" + params.to_query if params.count > 0

      ## Make the call
      _response = Curl::Easy.perform(_query.to_s) do |_curl|
        _curl.useragent = "Ruby/Curb/TFGM_API/#{TFGM_VERSION}"
        _curl.headers['DevKey'] = @developer_key
        _curl.headers['AppKey'] = @application_key
        _curl.headers['Content-type'] = 'text/json'
      end

      ## Exception catching to make it work smoothly.
      begin
        _result = JSON.parse(_response.body_str) ## Parse

        ## Right, throw an error if we can't authorize.
        throw TFGM_Error::DeveloperOrApplicationKeyNotAccepted if _result['Message'].eql?("Authorization has been denied for this request.")
      rescue TypeError, JSON::ParserError
        ## Empty by design.
      end

      _result
    end

    ##
    ## Show all car parks
    ##
    def carparks(page = 0, per_page = 10, options = {})
      _options = { :pageIndex => page, :pageSize => per_page }

      ## This validates whether a car park state is valid.
      if options.has_key?('state') then
        _enums = self._call('/api/enums')
        throw TFGM_Error::CarParkStateTypeInvalid unless _enums.member?(options['state'])
      end

      self._call('/api/carparks', _options.merge(options))
    end

    ##
    ## Show a single car park
    ##
    def carpark(id, options = {})
      self._call('/api/carparks/' + id.to_s, options)
    end

    ##
    ## Show states of car parks.
    ##
    def carpark_states(options = {})
      self._call('/api/enums', options)
    end

    ##
    ## Hi, buses.
    ##
    def routes(options = {})
      self._call("/api/routes", options)
    end

    def route(bus_code, options = {})
      self._call("/api/routes/#{bus_code.to_s}", options)
    end

    def is_route(bus_code, options = {})
      self.route(bus_code, options).count > 0
    end

    def buses_on_route(bus_code, options = {})
      self._call("/api/routes/#{bus_code.to_s}/buses", options)
    end

    def stops_on_route(bus_code, options = {})
      self._call("/api/routes/#{bus_code.to_s}/stops", options)
    end

    def bus_stops_near(lat, lng, options = {})
      _options = { "latitude" => lat, "longitude" => lng }
      self._call("/api/stops", _options.merge(options))
    end

    def bus_stop(atco_code, options = {})
      self._call("/api/stops/#{atco_code.to_s}", options)
    end

    def buses_on_stop(atco_code, options = {})
      self._call("/api/stops/#{atco_code}/route", options)
    end

    ##
    ## Journey times
    ##
    def journey_times(journey_id = 0, options = {})
      if journey_id > 0 then
        self._call("/api/journeytimes/#{journey_id.to_s}", options)
      else 
        self._call("/api/journeytimes", options)
      end
    end

    ##
    ## Version
    ##
    def version
      TFGM_VERSION
    end

  end
end

##
## Built by Bilaw.al, but please, be awesome and improve it :)
##