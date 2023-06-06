module MaileonRuby3
  class ContactFilter < Resource
    attr_accessor :id

    def initialize(apikey: nil, debug: false, id:)
      super(apikey: apikey, debug: debug)
      @id = id
      @url = "contactfilters/contactfilter/#{@id}/refresh"
    end

    def get_parameters(method: nil)
      '?async=true'
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

    def parse_body(body)
      body.to_s.empty?
    end
  end
end
