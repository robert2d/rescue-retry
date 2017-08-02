# Rescue::Retry [![Build Status](https://travis-ci.org/robert2d/rescue-retry.svg?branch=master)](https://travis-ci.org/robert2d/rescue-retry)

Wraps a instance method in a configurable retry handler with additional/optional delay logic as well.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescue-retry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescue-retry

## Usage

```ruby
require 'rescue/retry'

class StateCache
    extend Rescue::Retry

    # Simple
    rescue_retry :retrieve, Redis::CannotConnectError

    # Verbose
    rescue_retry :update, [Redis::CannotConnectError, ArgumentError],
                  max_attempts: 5, # optional
                  delay: :exponential # optional: :linear, :random

    def retrieve
      redis.get(key)
    end

    def update(data)
      redis.set(key, data)
    end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/robert2d/rescue-retry.

