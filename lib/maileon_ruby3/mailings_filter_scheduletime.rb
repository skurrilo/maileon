module MaileonRuby3
  class MailingsFilterScheduletime < Resource
    require 'nokogiri'

    DEFAULT_STANDARD_FIELDS = %w[state type name scheduleTime]

    def initialize(apikey: nil, debug: false)
      super(apikey: apikey, debug: debug)

      @url = "mailings/filter/scheduletime"
    end

    def get(schedule_time: nil)
      response = @session.get(:path => "#{@path}#{@url}#{get_parameters(schedule_time: schedule_time)}", :headers => get_headers_xml)
      return unless response[:status] == 200
      parse_body(response[:body])
    end

    def create
      raise RuntimeError.new('Not implemented.')
    end

    def update
      raise RuntimeError.new('Not implemented.')
    end

    def delete
      raise RuntimeError.new('Not implemented.')
    end

    def get_parameters(method: METHOD_GET, standard_fields: DEFAULT_STANDARD_FIELDS, schedule_time:)
      raise RuntimeError.new('scheduleTime must be a DateTime') if schedule_time.class != DateTime
      r = "?scheduleTime=#{CGI::escape(schedule_time.strftime('%Y-%m-%d %H:%M:%S'))}&beforeSchedulingTime=false&"
      standard_fields.each { |field| r = r + "fields=#{CGI::escape(field)}&"}
      r.chomp('&')
    end

    def parse_body(body)
      xml = Nokogiri::XML(body)
      mailings = []

      xml.xpath('/mailings/mailing').each do |m|
        mailing = {}
        mailing[:id] = m.at_xpath('id').content
        m.xpath('fields/field').each do |field|
          mailing[field.at_xpath('name').content.to_sym] = field.at_xpath('value').content
        end
        mailings.push(mailing)
      end
      mailings
    end
  end
end
