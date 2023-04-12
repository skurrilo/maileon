module MaileonRuby3
  class Transaction < Resource
    attr_accessor :email
    attr_accessor :type
    attr_accessor :content

    def initialize(apikey: nil, debug: false, email:)
      super(apikey: apikey, debug: debug)
      raise ArgumentError.new('email address must be provided.') if email.blank?

      @email = email
      @url = "transactions"
      @content = {}
    end

    def update
      raise RuntimeError.new('Transaction update not allowed.')
    end

    def get
      raise RuntimeError.new('Transaction get not allowed.')
    end

    def get_parameters(method: nil)
      "?ignore_invalid_transactions=false"
    end

    def get_headers_json
      header = super
      header["Content-Type"] = 'application/json'
      header
    end

    def add_content_var(key: nil, value: nil)
      return false if key.nil?
      key = key.to_sym
      if value.nil?
        @content.delete(key)
        return true
      end
      @content[key] = value
      true
    end

    def get_body
      contact = {
        email: @email,
        permission: 2,
      }
      [
        {
          type: @type,
          import: {
            contact: contact
          },
          content: @content
        }
      ]
    end
  end
end