require "foo_service/search"

module FooService
  class ItemDecorator
    attr_reader :content

    def initialize(content)
      @content = Hashie::Mash.new(content)
      @source = @content._source
    end
  end
end
