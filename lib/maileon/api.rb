require 'base64'
require 'excon'

module Maileon
  class API

    attr_accessor :host, :path, :apikey, :debug, :session

    def initialize(apikey=nil, debug=false)
      @host = 'https://api.maileon.com'
      @path = '/1.0/'

      unless apikey
        apikey = ENV['MAILEON_APIKEY']
      end

      raise 'You must provide Maileon API key' unless apikey

      @apikey = Base64.encode64(apikey).strip
      @debug = debug
      @session = Excon.new @host, :debug => debug
    end

    def create_contact(params, body={})
      raise ArgumentError.new("No parameters.") if params.empty?
      raise ArgumentError.new("Email is mandatory to create contact.") if params[:email].nil?
      raise Maileon::Errors::ValidationError.new("Invalid email format.") unless is_valid_email(params[:email])
      email = URI::escape(params[:email])
      permission = params[:permission] ||= 1
      sync_mode = params[:sync_mode] ||= 2
      doi = params[:doi] ||= true
      doiplus = params[:doiplus] ||= true
      url = "contacts/#{email}?permission=#{permission}&sync_mode=#{sync_mode}&doi=#{doi}&doiplus=#{doiplus}"
      # TODO enable POST, add tests
      #@session.post(:path => "#{@path}#{url}", :headers => get_headers, :expects => [200, 201], :body => body.to_json)
    end

    private

    def is_valid_email(email)
      !/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/.match(email).nil?
    end

  end
end