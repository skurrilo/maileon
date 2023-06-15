module MaileonRuby3
  class   Contact < Resource
    require 'nokogiri'

    attr_accessor :address,
                  :birthday,
                  :city,
                  :country,
                  :external_id,
                  :firstname,
                  :gender,
                  :hnr,
                  :lastname,
                  :locale,
                  :organisation,
                  :region,
                  :salutation,
                  :state,
                  :title,
                  :zip
    # email is (a) primary id for contact in maileon
    attr_accessor :email
    attr_accessor :custom_fields

    # get params for contacts
    attr_accessor :permission
    attr_accessor :sync_mode
    attr_accessor :src
    attr_accessor :subscription_page
    attr_accessor :doi
    attr_accessor :doiplus
    attr_accessor :doimailing

    DEFAULT_STANDARD_FIELDS = %w[ADDRESS BIRTHDAY CITY COUNTRY FIRSTNAME GENDER HNR LASTNAME LOCALE REGION SALUTATION STATE TITLE ZIP]

    def initialize(apikey: nil, debug: false, email:)
      super(apikey: apikey, debug: debug)
      raise ArgumentError.new('email address must be provided.') if email.blank?

      @email = email
      @url = "contacts/email/#{CGI::escape(email)}"
      @custom_fields = {}
      @json = false
      @permission = 1
      @sync_mode = 2
    end

    def get
      response = @session.get(:path => "#{@path}#{@url}#{get_parameters(custom_fields: @custom_fields)}", :headers => get_headers_xml)
      return false unless response[:status] == 200
      parse_body(response[:body])
      response
    end

    def get_parameters(method: METHOD_GET, standard_fields: DEFAULT_STANDARD_FIELDS, custom_fields: [])
      case method
      when METHOD_UPDATE
      when METHOD_CREATE
        params = {}
        params[:src] = src unless src.nil?
        params[:permission] = permission unless permission.nil?
        params[:sync_mode] = sync_mode unless sync_mode.nil?
        params[:subscription_page] = subscription_page unless subscription_page.nil?
        params[:doi] = doi unless doi.nil?
        params[:doiplus] = doiplus unless doiplus.nil?
        params[:doimailing] = doimailing unless doimailing.nil?
        return params.empty? ? '' : "?#{params.to_query}"
      when METHOD_DELETE
        return ''
      else
        r = '?'
        standard_fields.each { |field| r = r + "standard_field=#{field}&"}
        custom_fields.each { |key, value| r = r + "custom_field=#{CGI::escape(key.to_s)}&"}
        return r.chomp('&')
      end
    end

    def add_custom_field(key, value)
      @custom_fields[key.to_sym] = value
    end

    def get_body_as_xml
      body = get_body
      sf = ""
      cf = ""
      body[:standard_fields].each do |key, value|
        if value.kind_of? String
          value = value.encode(:xml => :text)
        end
        sf << "<field><name>#{key.upcase}</name><value>#{value}</value></field>"
      end
      body[:custom_fields].each do |key, value|
        if value.kind_of? String
          value = value.encode(:xml => :text)
        end
        cf << "<field><name>#{key}</name><value>#{value}</value></field>"
      end
      "<contact><email>#{@email.encode(:xml => :text)}</email><standard_fields>#{sf}</standard_fields><custom_fields>#{cf}</custom_fields></contact>"
    end

    def get_body
      standard_fields = {}
      standard_fields[:address] = address unless address.nil?
      standard_fields[:birthday] = birthday unless birthday.nil?
      standard_fields[:city] = city unless city.nil?
      standard_fields[:country] = country unless country.nil?
      standard_fields[:external_id] = external_id unless external_id.nil?
      standard_fields[:firstname] = firstname unless firstname.nil?
      standard_fields[:gender] = gender unless gender.nil?
      standard_fields[:hnr] = hnr unless hnr.nil?
      standard_fields[:lastname] = lastname unless lastname.nil?
      standard_fields[:locale] = locale unless locale.nil?
      standard_fields[:organisation] = organisation unless organisation.nil?
      standard_fields[:region] = region unless region.nil?
      standard_fields[:salutation] = salutation unless salutation.nil?
      standard_fields[:state] = state unless state.nil?
      standard_fields[:title] = title unless title.nil?
      standard_fields[:zip] = zip unless zip.nil?

      {
        'custom_fields': @custom_fields,
        'standard_fields': standard_fields
      }
    end

    def parse_body(body)
      xml = Nokogiri::XML(body)
      @email = xml.at_xpath('/contact/email').text
      @permission = xml.at_xpath('/contact/permission').text.to_i
      xml.xpath('/contact/standard_fields/field').each do |xml_field|
        field_name = xml_field.at_xpath('name').content.downcase
        field_value = xml_field.at_xpath('value').text
        self.send("#{field_name}=", field_value)
      end
      xml.xpath('/contact/custom_fields/field').each do |xml_field|
        field_name = xml_field.at_xpath('name').content
        field_value = xml_field.at_xpath('value').text
        @custom_fields[field_name.to_sym] = field_value
      end
    end
  end
end
