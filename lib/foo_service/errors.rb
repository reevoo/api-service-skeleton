module FooService

  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end

end
