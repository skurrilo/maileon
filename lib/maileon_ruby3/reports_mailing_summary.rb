module MaileonRuby3
  class ReportsMailingSummary < Resource
    require 'nokogiri'

    def initialize(apikey: nil, debug: false)
      super(apikey: apikey, debug: debug)

      @url = "reports/mailing_summaries"
    end

    def get(mailing_id: nil)
      raise RuntimeError('Mailing-ID must be set.') if mailing_id.nil?
      response = @session.get(:path => "#{@path}#{@url}#{get_parameters(mailing_id: mailing_id)}", :headers => get_headers_xml)
      return unless response[:status] == 200
      parse_body(response[:body])
    end

    def create
      raise RuntimeError('Not implemented.')
    end

    def update
      raise RuntimeError('Not implemented.')
    end

    def delete
      raise RuntimeError('Not implemented.')
    end

    def get_parameters(method: METHOD_GET, mailing_id: nil)
      "?mailing_id=#{CGI::escape(mailing_id.to_s)}"
    end

    def parse_body(body)
      xml = Nokogiri::XML(body)
      summary = {}

      xml.xpath('/mailing_summaries/mailing_summary').each do |m|
        summary[:mailing_id]       = m.at_xpath('mailing_id').content
        summary[:recipients]       = m.at_xpath('recipients').content
        summary[:opens]            = m.at_xpath('opens').content
        summary[:opens_unique]     = m.at_xpath('opens_unique').content
        summary[:clicks]           = m.at_xpath('clicks').content
        summary[:clicks_unique]    = m.at_xpath('clicks_unique').content
        summary[:bounces]          = m.at_xpath('bounces').content
        summary[:unsubscriptions]  = m.at_xpath('unsubscriptions').content
        summary[:replies]          = m.at_xpath('replies').content
        summary[:archived]         = m.at_xpath('archived').content == "true" ? true : false
      end
      summary
    end
  end
end
