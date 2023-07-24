# frozen_string_literal: true

require 'test_helper'

module Swiss
  class TestSwiss < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Swiss::VERSION
    end

    def test_simple_swiss
      enrico = Player.new('Enrico')
      nicola = Player.new('Nicola')
      luca = Player.new('Luca')
      alberto = Player.new('Alberto')
      players = [enrico, nicola, luca, alberto]

      assert_equal %w[Enrico Nicola Luca Alberto], players.sort.map(&:name)

      t = Tournament.new(players, first_pairing_proc: ->(plys) { plys.each_slice(2).to_a })

      assert_equal 2, t.total_rounds

      # Round 1

      assert_equal 1, t.rounds.size
      assert_equal 2, t.current_round.size
      assert_equal 'Enrico vs Nicola', t.table(0).to_s
      assert_equal 'Luca vs Alberto', t.table(1).to_s
      t.set_table_result(0, 2, 0)
      t.set_table_result(1, 2, 1)
      t.next_round

      # Round 2

      refute_predicate t, :finished?
      assert_equal %w[Enrico Luca Nicola Alberto], t.standings.map(&:name)
      assert_equal 3, enrico.mp
      assert_equal 33.33, enrico.omw
      assert_equal 100.0, enrico.gw
      assert_equal 33.33, enrico.ogw
      assert_equal 100.0, enrico.mw
      assert_equal 0, nicola.mp
      assert_equal 100.0, nicola.omw
      assert_equal 33.33, nicola.gw
      assert_equal 100.0, nicola.ogw
      assert_equal 33.33, nicola.mw
      assert_equal 3, luca.mp
      assert_equal 33.33, luca.omw
      assert_equal 66.67, luca.gw
      assert_equal 33.33, luca.ogw
      assert_equal 100.0, luca.mw
      assert_equal 0, alberto.mp
      assert_equal 100.0, alberto.omw
      assert_equal 33.33, alberto.gw
      assert_equal 66.67, alberto.ogw
      assert_equal 33.33, alberto.mw

      assert_equal 2, t.rounds.size
      assert_equal 2, t.current_round.size
      assert_equal 'Enrico vs Luca', t.table(0).to_s
      assert_equal 'Nicola vs Alberto', t.table(1).to_s
      t.set_table_result(0, 2, 0)
      t.set_table_result(1, 2, 1)
      t.next_round

      # Round 3

      assert_predicate t, :finished?
      assert_equal %w[Enrico Nicola Luca Alberto], t.standings.map(&:name)
      assert_equal 6, enrico.mp
      assert_equal 50.0, enrico.omw
      assert_equal 100.0, enrico.gw
      assert_equal 40.0, enrico.ogw
      assert_equal 100.0, enrico.mw
      assert_equal 3, nicola.mp
      assert_equal 66.66, nicola.omw
      assert_equal 40.0, nicola.gw
      assert_equal 66.66, nicola.ogw
      assert_equal 50.0, nicola.mw
      assert_equal 3, luca.mp
      assert_equal 66.66, luca.omw
      assert_equal 40.0, luca.gw
      assert_equal 66.66, luca.ogw
      assert_equal 50.0, luca.mw
      assert_equal 0, alberto.mp
      assert_equal 50.0, alberto.omw
      assert_equal 33.33, alberto.gw
      assert_equal 40.0, alberto.ogw
      assert_equal 33.33, alberto.mw
    end

    def test_swiss_with_drop
      enrico = Player.new('Enrico')
      nicola = Player.new('Nicola')
      luca = Player.new('Luca')
      alberto = Player.new('Alberto')
      players = [enrico, nicola, luca, alberto]

      assert_equal %w[Enrico Nicola Luca Alberto], players.sort.map(&:name)

      t = Tournament.new(players, first_pairing_proc: ->(plys) { plys.each_slice(2).to_a })

      # Round 1

      assert_equal 1, t.rounds.size
      assert_equal 2, t.current_round.size
      assert_equal 'Enrico vs Nicola', t.table(0).to_s
      assert_equal 'Luca vs Alberto', t.table(1).to_s
      t.set_table_result(0, 2, 0, p2_drop: true)
      t.set_table_result(1, 2, 1, p1_drop: true)
      t.next_round

      # Round 2

      refute_predicate t, :finished?
      assert_equal %w[Enrico Luca Nicola Alberto], players.sort.map(&:name)

      assert_equal 2, t.rounds.size
      assert_equal 1, t.current_round.size
      assert_equal 'Enrico vs Alberto', t.table(0).to_s
      t.set_table_result(0, 2, 0)
      t.next_round

      # Round 3

      assert_predicate t, :finished?
      assert_equal %w[Enrico Luca Nicola Alberto], players.sort.map(&:name)
      assert_equal 6, enrico.mp
      assert_equal 33.33, enrico.omw
      assert_equal 100.0, enrico.gw
      assert_equal 33.33, enrico.ogw
      assert_equal 100.0, enrico.mw
      assert_equal 0, nicola.mp
      assert_equal 100.0, nicola.omw
      assert_equal 33.33, nicola.gw
      assert_equal 100.0, nicola.ogw
      assert_equal 33.33, nicola.mw
      assert_equal 3, luca.mp
      assert_equal 33.33, luca.omw
      assert_equal 66.67, luca.gw
      assert_equal 33.33, luca.ogw
      assert_equal 100.0, luca.mw
      assert_equal 0, alberto.mp
      assert_equal 100.0, alberto.omw
      assert_equal 33.33, alberto.gw
      assert_equal 83.34, alberto.ogw
      assert_equal 33.33, alberto.mw
    end

    def test_swiss_with_bye
      enrico = Player.new('Enrico')
      nicola = Player.new('Nicola')
      luca = Player.new('Luca')
      alberto = Player.new('Alberto')
      federico = Player.new('Federico')
      players = [enrico, nicola, luca, alberto, federico]

      assert_equal %w[Enrico Nicola Luca Alberto Federico], players.sort.map(&:name)

      t = Tournament.new(players, first_pairing_proc: ->(_plys) { [[alberto, enrico], [luca, nicola], [federico, nil]] })

      # Round 1

      assert_equal 1, t.rounds.size
      assert_equal 3, t.current_round.size
      assert_equal 'Alberto vs Enrico', t.table(0).to_s
      assert_equal 'Luca vs Nicola', t.table(1).to_s
      assert_equal 'Federico bye', t.table(2).to_s
      t.set_table_result(0, 1, 2)
      t.set_table_result(1, 1, 1, 1)
      t.next_round([[enrico, nicola], [federico, luca], [alberto, nil]])

      # Round 2

      refute_predicate t, :finished?
      assert_equal %w[Enrico Federico Nicola Luca Alberto], t.standings.map(&:name)
      assert_equal 3, enrico.mp
      assert_equal 33.33, enrico.omw
      assert_equal 66.67, enrico.gw
      assert_equal 33.33, enrico.ogw
      assert_equal 1, nicola.mp
      assert_equal 33.33, nicola.omw
      assert_equal 44.44, nicola.gw
      assert_equal 44.44, nicola.ogw
      assert_equal 1, luca.mp
      assert_equal 33.33, luca.omw
      assert_equal 44.44, luca.gw
      assert_equal 44.44, luca.ogw
      assert_equal 0, alberto.mp
      assert_equal 100.0, alberto.omw
      assert_equal 33.33, alberto.gw
      assert_equal 66.67, alberto.ogw
      assert_equal 3, federico.mp
      assert_equal 0.0, federico.omw
      assert_equal 100.0, federico.gw
      assert_equal 0.0, federico.ogw

      assert_equal 2, t.rounds.size
      assert_equal 3, t.current_round.size
      assert_equal 'Enrico vs Nicola', t.table(0).to_s
      assert_equal 'Federico vs Luca', t.table(1).to_s
      assert_equal 'Alberto bye', t.table(2).to_s
      t.set_table_result(0, 2, 0)
      t.set_table_result(1, 2, 1)
      t.next_round([[enrico, federico], [alberto, luca], [nicola, nil]])

      # Round 3

      refute_predicate t, :finished?
      assert_equal %w[Federico Enrico Alberto Luca Nicola], t.standings.map(&:name)
      assert_equal 6, enrico.mp
      assert_equal 33.33, enrico.omw
      assert_equal 80.0, enrico.gw
      assert_equal 33.33, enrico.ogw
      assert_equal 1, nicola.mp
      assert_equal 66.66, nicola.omw
      assert_equal 33.33, nicola.gw
      assert_equal 59.45, nicola.ogw
      assert_equal 1, luca.mp
      assert_equal 66.66, luca.omw
      assert_equal 38.89, luca.gw
      assert_equal 50.0, luca.ogw
      assert_equal 3, alberto.mp
      assert_equal 100.0, alberto.omw
      assert_equal 60.0, alberto.gw
      assert_equal 80.0, alberto.ogw
      assert_equal 6, federico.mp
      assert_equal 33.33, federico.omw
      assert_equal 80.0, federico.gw
      assert_equal 38.89, federico.ogw

      assert_equal 3, t.rounds.size
      assert_equal 3, t.current_round.size
      assert_equal 'Enrico vs Federico', t.table(0).to_s
      assert_equal 'Alberto vs Luca', t.table(1).to_s
      assert_equal 'Nicola bye', t.table(2).to_s
      t.set_table_result(0, 2, 1)
      t.set_table_result(1, 2, 1)
      t.next_round

      assert_predicate t, :finished?
      assert_equal %w[Enrico Federico Alberto Nicola Luca], t.standings.map(&:name)
      assert_equal 9, enrico.mp
      assert_equal 44.44, enrico.omw
      assert_equal 75.0, enrico.gw
      assert_equal 44.44, enrico.ogw
      assert_equal 4, nicola.mp
      assert_equal 66.66, nicola.omw
      assert_equal 47.62, nicola.gw
      assert_equal 56.02, nicola.ogw
      assert_equal 1, luca.mp
      assert_equal 44.44, luca.omw
      assert_equal 37.04, luca.gw
      assert_equal 44.44, luca.ogw
      assert_equal 6, alberto.mp
      assert_equal 66.66, alberto.omw
      assert_equal 62.5, alberto.gw
      assert_equal 56.02, alberto.ogw
      assert_equal 6, federico.mp
      assert_equal 66.66, federico.omw
      assert_equal 62.5, federico.gw
      assert_equal 56.02, federico.ogw
    end

    def test_raises_if_same_oppo
      enrico = Player.new('Enrico')
      nicola = Player.new('Nicola')
      luca = Player.new('Luca')
      t = Tournament.new([enrico, nicola, luca], first_pairing_proc: ->(_plys) { [[enrico, nicola], [luca, nil]] })
      t.set_table_result(0, 2, 0)
      error = assert_raises RuntimeError do
        t.next_round([[enrico, nicola], [luca, nil]])
      end

      assert_equal 'Enrico has already challenged Nicola', error.message
    end

    def test_player_to_s
      enrico = Player.new('Enrico')
      expected_output = <<~STRING
        Enrico
          mp: 0
         omw: 33.33
          gw: 33.33
         ogw: 33.33
          mw: 33.33
      STRING

      assert_equal expected_output, enrico.to_s + "\n"
    end

    def test_big_swiss
      players = Array.new(1001) { Player.new('P') }
      t = Tournament.new(players)
      loop do
        t.current_round.each_with_index do |_match, i|
          result =
            case rand(5)
            when 0
              [2, 0]
            when 1
              [2, 1]
            when 2
              [1, 2]
            when 3
              [0, 2]
            when 4
              [1, 1]
            end
          t.set_table_result(i, *result)
        end
        t.next_round
        break if t.finished?
      end
    end
  end
end
