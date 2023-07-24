module Swiss
  # Represents a tournament with Magic the Gathering Swiss rules.
  #
  # The tournament unfolds as follows:
  #
  # 1. For the first round, players are randomly paired.
  # 2. After each round, the standings are calculated.
  # 3. Players are paired based on their partial ranking in a strict manner,
  # rank 1 will compete against rank 2, rank 3 against rank 4, and so on. It
  # is ensured that a player does not face the same opponent multiple times.
  # 4. This process continues until the total number of rounds is reached,
  # which is `log2(number_of_players)`.
  #
  # The following tiebreakers are used to determine the standings:
  #
  # 1. Match points ({Player.mp})
  # 2. Opponents' match-win percentage ({Player.omw})
  # 3. Game-win percentage ({Player.gw})
  # 4. Opponents' game-win percentage ({Player.ogw})
  # @see https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf Magic the Gathering Tournament Rules
  class Tournament
    # List of players.
    # @return [Array<Player>]
    attr_reader :players

    # Expected number of Swiss rounds.
    # @return [Integer]
    attr_reader :total_rounds

    # Rounds.
    # @return [Array<Array<Match>>]
    attr_reader :rounds

    # Initialize a tournament. All existing players will be reset with
    # {Player.reset_stats}.
    # @param players [Array<Player>,Array<String>] List of players
    #  participating in the tournament. It can be an array of String with
    #  player names or an array of {Player}.
    # @param first_pairing_proc [Proc] Proc used for first round pairing. Must
    #  return an array of player tuples.
    def initialize(players, first_pairing_proc: ->(plys) { plys.shuffle.each_slice(2).to_a })
      @players = players.map { |player| player.is_a?(Player) ? player.reset_stats : Player.new(player) }
      @total_rounds = Math.log2(@players.size).ceil
      @rounds = [pair_players(first_pairing_proc.call(@players))]
    end

    # Returns the current standings.
    # @return [Array<Player>]
    def standings
      @players.sort
    end

    # Return the current round.
    # @return [Array<Match>]
    def current_round
      @rounds.last
    end

    # Returns the match being played at table "table_number".
    # @param table_number [Integer] The match index of the current round.
    # @return [Match]
    def table(table_number)
      current_round[table_number]
    end

    # Record the results for the table "table_number".
    # @param table_number [Integer] The match index of the current round.
    # @param p1_gwc [Integer] Player 1 game win count.
    # @param p2_gwc [Integer] Player 2 game win count.
    # @param gdc [Integer] Number of tied games.
    # @param p1_drop [Boolean] Player 1 drop after this match.
    # @param p2_drop [Boolean] Player 2 drop after this match.
    # @return [String] The record of the match (Wins–Losses–Draws).
    def set_table_result(table_number, p1_gwc, p2_gwc, gdc = 0, p1_drop: false, p2_drop: false)
      current_round[table_number].result(p1_gwc, p2_gwc, gdc, p1_drop: p1_drop, p2_drop: p2_drop)
    end

    # Go to the next round. Calculate the current standings and create new
    # round if {.total_rounds} not reached.
    # @raise RuntimeError If the round is not finished. A round is considered
    #  finished when all the results have been recorded with
    #  {.set_table_result} method.
    # @param pairing [Array<Tuple<Player>>] Override the pairing for the next
    #  round.
    # @return [void]
    def next_round(pairing = nil)
      raise 'The current round is not yet complete. Please provide results for all the tables.' unless self.round_finished?

      self.calculate_scores
      @rounds << pair_players(pairing) if @rounds.size < @total_rounds
    end

    # Returns `true` if the current round is finished. A round is considered
    # finished when all the results have been recorded with
    # {.set_table_result} method.
    # @return [Boolean]
    def round_finished?
      current_round.all?(&:finished?)
    end

    # Returns `true` if the tournament has ended. A tournament is considered
    # finished when has reached {.total_rounds} rounds and all rounds are
    # finished.
    # @return [Boolean]
    def finished?
      @rounds.size == @total_rounds && round_finished?
    end

    private

    def pair_players(tables = nil)
      if tables.nil?
        tables = []
        pool = @players.reject(&:dropped?).sort.dup
        while pool.size > 1
          p1 = pool.shift
          pool.each do |p2|
            next if p1.opponents.include?(p2)

            pool.delete(p2)
            tables << [p1, p2]
            break
          end
        end
        tables << [pool.first, nil] if pool.size == 1
      end
      return tables.map { |(player1, player2)| Match.new(player1, player2) }
    end

    def calculate_player_stats(player, skip_bye:)
      match_points = 0
      match_played = 0
      game_points = 0
      game_played = 0
      player.matches.each do |match|
        next if match.bye? && skip_bye

        match_points += match.match_points(player)
        match_played += 1
        game_points += match.game_points(player)
        game_played += match.games
      end
      return {
        mp: match_points,
        mw: [33.33, (match_points / (match_played * 3.0) * 100.0).round(2)].max,
        gw: [33.33, (game_points / (game_played * 3.0) * 100.0).round(2)].max
      }
    end

    def calculate_scores
      @players.each do |player|
        stats = calculate_player_stats(player, skip_bye: false)
        player.mp = stats[:mp]
        player.mw = stats[:mw]
        player.gw = stats[:gw]
        oppo_stats = player.opponents.map do |oppo|
          calculate_player_stats(oppo, skip_bye: true)
        end
        if oppo_stats.empty?
          player.omw = 0.0
          player.ogw = 0.0
        else
          player.omw = (oppo_stats.sum { |s| s[:mw] } / oppo_stats.size).round(2)
          player.ogw = (oppo_stats.sum { |s| s[:gw] } / oppo_stats.size).round(2)
        end
      end
    end
  end
end
