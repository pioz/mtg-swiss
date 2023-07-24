![build](https://github.com/pioz/mtg-swiss/workflows/Ruby/badge.svg)
[![codecov](https://codecov.io/gh/pioz/mtg-swiss/branch/master/graph/badge.svg?token=bsSUOW6wWa)](https://codecov.io/gh/pioz/mtg-swiss)
[![rdoc](https://img.shields.io/badge/yard-doc-blue)](https://pioz.github.io/mtg-swiss)

# MTG Swiss

A lightweight Ruby library implementing Magic the Gathering Swiss tournament
rules. Easily integrate points systems, ranking, and tiebreaker rules for
fair and competitive event management. Elevate your tournaments with minimal
effort.

The tournament unfolds as follows:

1. For the first round, players are randomly paired.
2. After each round, the standings are calculated.
3. Players are paired based on their partial ranking in a strict manner,
   rank 1 will compete against rank 2, rank 3 against rank 4, and so on. It is
   ensured that a player does not face the same opponent multiple times.
4. This process continues until the total number of rounds is reached, which is `log2(number_of_players)`.

The following tiebreakers are used to determine the standings:

1. Match points
2. Opponents' match-win percentage
3. Game-win percentage
4. Opponents' game-win percentage

[Official Wizards of the Coast Tournament Rules](https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf)

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
