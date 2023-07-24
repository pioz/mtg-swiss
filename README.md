![build](https://github.com/pioz/mtg-swiss/workflows/Ruby/badge.svg)
[![codecov](https://codecov.io/gh/pioz/mtg-swiss/branch/master/graph/badge.svg?token=bsSUOW6wWa)](https://codecov.io/gh/pioz/mtg-swiss)

# MTG Swiss

A lightweight Ruby library implementing Magic the Gathering Swiss tournament
rules. Easily integrate points systems, ranking, and tiebreaker rules for
fair and competitive event management. Elevate your tournaments with minimal
effort.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add 'mtg-swiss'

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install 'mtg-swiss'

## Usage

```ruby
players = [
  Swiss::Player('Enrico'),
  Swiss::Player('Nicola'),
  Swiss::Player('Luca'),
  Swiss::Player('Alberto')
]

t = Swiss::Tournament.new(players)
t.set_table_result(0, 2, 0)
t.set_table_result(1, 2, 1)
t.next_round
t.standings
t.finished?
```

All docs available here: https://pioz.github.io/mtg-swiss

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pioz/mtg-swiss.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
