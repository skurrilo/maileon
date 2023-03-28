module MaileonRuby3
  class Transaction < Resource
    attr_accessor :email
    attr_accessor :type

    def initialize(apikey: nil, debug: false, email:)
      super(apikey: apikey, debug: debug)
      raise ArgumentError.new('email address must be provided.') if email.blank?

      @email = email
      @url = "transactions"
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
      header["Content-Type".to_sym] = 'application/json'
      header
    end

    def get_body
      [
        {
          type: @type,
          import: {
            contact: {
              email: @email,
              permission: 2,
            }
          },
          content: {
            username: 'skurrilo'
          }
        }
      ]
    end
  end
end