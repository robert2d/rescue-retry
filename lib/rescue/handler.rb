require 'logger'

module Rescue
  class Handler
    attr_reader :errors, :logger, :attempt, :max_attempts, :delay

    def initialize(options = {})
      @errors = options[:errors] || []
      @max_attempts = options[:max_attempts] || 3
      @delay = options[:delay] || :none
      @logger = options[:logger] || ::Logger.new($stdout)
      @attempt = 1
    end

    def call(&block)
      block.call
    rescue *errors => e
      log_attempt(e)
      raise if max_attempts?
      @attempt += 1
      sleep delay_retry(attempt) unless delay == :none
      retry
    end

    private

    def delay_retry(attempt)
      return attempt ** 2 if delay == :exponential
      return attempt * 2 if delay == :linear
      return (rand + 1) * 0.5 * attempt if delay == :random
      raise ArgumentError, "unknown delay \"#{delay}\". accepts: :exponential, :linear and :random"
    end

    def log_attempt(e)
      logger.warn "Failed attempt (#{attempt} of #{max_attempts}) #<#{e.class.name}.#{e.message}>"
      logger.error "maximum attempts (#{max_attempts}) reached" if max_attempts?
    end

    def max_attempts?
      attempt == max_attempts
    end
  end
end
