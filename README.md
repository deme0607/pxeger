# Pxeger

Random string gemerator from regular expression.
Refered to [cho45/String_random.js](https://github.com/cho45/String_random.js)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pxeger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pxeger

## Usage

```ruby
require 'pxeger'

pxeger = Pxeger.new(/[a-z]{10}/)
pxeger.generate #=> "ovwjqgerwb"

pxeger = Pxeger.new(/(ワー?ン!)?+(ワン!){1,4}/)
pxeger.generate #=> "ワン!"
pxeger.generate #=> "ワーン!ワン!ワン!ワン!ワン!"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pxeger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
