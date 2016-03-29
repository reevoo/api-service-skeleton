module FooService
  module ES
    extend self

    INDEX = ENV["ES_INDEX"]

    def instance
      @instance ||= Elasticsearch::Client.new(url: connect_url)
    end

    def connect_url
      ENV["ES_URL"]
    end
  end
end
