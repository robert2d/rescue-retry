require 'rescue/version'
require 'rescue/handler'

module Rescue
  module Retry
    def rescue_retry(method, errors, options = {})
      proxy = Module.new do
        define_method(method) do |*args|
          Handler.new(
            {
              errors: Array(errors),
              logger: respond_to?(:logger) ? logger : nil
            }.merge(options)
          ).call do
            super *args
          end
        end
      end
      self.prepend proxy
    end
  end
end
