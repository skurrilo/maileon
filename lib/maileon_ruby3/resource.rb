module MaileonRuby3
  class Resource
    attr_accessor :api_url_path

    METHOD_GET = 'get'
    METHOD_CREATE = 'create'
    METHOD_UPDATE = 'update'
    METHOD_DELETE = ''

    def initialize(apikey:nil, debug: false)
      @host = 'https://api.maileon.com'
      @path = '/1.0/'
      @url  = 'ping'
      @json = false

      unless apikey
        apikey = ENV['MAILEON_APIKEY']
      end
      raise ArgumentError.new('You must provide Maileon API key') unless apikey

      @api_key_header = "Basic #{Base64.encode64(apikey).strip}"
      @session = Excon.new @host, :debug => debug
    end

    def create
      response = @session.post(:path => "#{@path}#{@url}#{get_parameters(method: METHOD_CREATE)}", :headers => get_headers_json, :body => get_body_as_json)
      return if response[:status] == 200 or response[:status] == 201
      raise RuntimeError.new("API call did not complete. Status: #{response.to_json}")
    end

    def update
      response = @session.put(:path => "#{@path}#{@url}#{get_parameters(method: METHOD_UPDATE)}", :headers => get_headers_xml, :body => get_body_as_xml)
      return if response[:status] == 200 or response[:status] == 201
      raise RuntimeError.new("API call did not complete. Status: #{response.to_json}")
    end

    def get
      repsonse = @session.get(:path => "#{@path}#{@url}#{get_parameters}", :headers => get_headers_xml)
      parse_body(repsonse[:body])
    end

    def get_headers_json
      get_headers(json: true)
    end

    def get_headers_xml
      get_headers(json: false)
    end

    def get_headers(json: true)
      {
        "Content-Type" => "application/vnd.maileon.api+#{ json ? 'json' : 'xml'}; charset=utf-8",
        "Authorization" => @api_key_header
      }
    end

    def get_parameters(method: METHOD_GET)
      ''
    end

    def get_body_as_xml
      get_body.to_xml
    end

    def get_body_as_json
      get_body.to_json
    end

    def get_body
      ''
    end

    def parse_body(body)
      # TODO
      body
    end
  end
end
