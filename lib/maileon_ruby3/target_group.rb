module MaileonRuby3
  class TargetGroup < Resource
    require 'nokogiri'

    def initialize(apikey: nil, debug: false)
      super(apikey: apikey, debug: debug)

      @url = "targetgroups"
    end

    def get_all
      repsonse = @session.get(:path => "#{@path}#{@url}#{get_parameters}", :headers => get_headers_xml)
      parse_body(repsonse[:body])
    end

    def get_parameters(method: nil)
      '?page_index=1&page_size=50'
    end

    def create
      raise RuntimeError('Not implemented.')
    end

    def update
      raise RuntimeError('Not implemented.')
    end

    def get
      raise RuntimeError('Not implemented.')
    end

    def delete
      raise RuntimeError('Not implemented.')
    end

    def parse_body(body)
      xml = Nokogiri::XML(body)
      targetgroups = []

      xml.xpath('/targetgroups/targetgroup').each do |group|
        targetgroup = {}
        targetgroup[:id] = group.at_xpath('id').content
        targetgroup[:name] = group.at_xpath('name').content
        targetgroup[:author] = group.at_xpath('author').content
        targetgroup[:type] = group.at_xpath('type').content
        targetgroup[:state] = group.at_xpath('state').content
        targetgroup[:contact_filter_name] = group.at_xpath('contact_filter_name').content
        targetgroup[:contact_filter_id] = group.at_xpath('contact_filter_id').content
        targetgroup[:evaluated] = group.at_xpath('evaluated').content
        targetgroup[:created] = group.at_xpath('created').content
        targetgroup[:updated] = group.at_xpath('updated').content
        targetgroup[:count_contacts] = group.at_xpath('count_contacts').content
        targetgroup[:count_active_contacts] = group.at_xpath('count_active_contacts').content
        targetgroups.push(targetgroup)
      end
      targetgroups
    end
  end
end
