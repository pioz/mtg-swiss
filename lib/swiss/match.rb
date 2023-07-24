module Swiss
  # Class that rappresent a match in the swiss tournament.
  class Match
    # Player 1 of the match.
    # @return [Player]
    attr_reader :p1
    # Player 2 of the match. Can be `nil` if player 1 win the match for a
    # bye.
    # @return [Player,nil]
    attr_reader :p2

    # Player 1 Game Win Count.
    # @return [Integer]
    attr_reader :p1_gwc

    # Player 2 Game Win Count.
    # @return [Integer]
    attr_reader :p2_gwc

    # Game Draw Count.
    # @return [Integer]
    attr_reader :gdc

    # Initialize the match.
    # @param player1 [Player] The player 1
    # @param player2 [Player] The player 2
    # @raise RuntimeError If player 1 has already challenged player 2 or viceversa.
    def initialize(player1, player2)
      @p1 = player1
      @p2 = player2
      @p1.matches << self
      if @p2
        @p2.matches << self
        @bye = false
        raise "#{@p1.name} has already challenged #{@p2.name}" if @p1.opponents.include?(@p2)
        raise "#{@p2.name} has already challenged #{@p1.name}" if @p2.opponents.include?(@p1)

        @p1.opponents << @p2
        @p2.opponents << @p1
      else
        @bye = true
        @p1_gwc = 2
        @p2_gwc = 0
        @gdc = 0
      end
    end

    # Print the match.
    # @return [String]
    def to_s
      return "#{@p1.name} bye" if @p2.nil?

      return "#{@p1.name} vs #{@p2.name}"
    end

    # Set the match result.
    # @param p1_gwc [Integer] Player 1 game win count.
    # @param p2_gwc [Integer] Player 2 game win count.
    # @param gdc [Integer] Number of tied games.
    # @param p1_drop [Boolean] Player 1 drop after this match.
    # @param p2_drop [Boolean] Player 2 drop after this match.
    # @return [String] The record of the match (Wins–Losses–Draws).
    def result(p1_gwc, p2_gwc, gdc = 0, p1_drop: false, p2_drop: false)
      @p1_gwc = p1_gwc
      @p2_gwc = p2_gwc
      @gdc = gdc
      @p1.drop = p1_drop
      @p2.drop = p2_drop if @p2
      return self.record
    end

    # Returns `true` if it is a bye match.
    # @return [Boolean]
    def bye?
      @bye
    end

    # Returns the match points gained from "player".
    # @param player [Player]
    # @return [Integer]
    def match_points(player)
      if @p1 == player
        return 3 if @p1_gwc == 2
        return 0 if @p2_gwc == 2
      else
        return 3 if @p2_gwc == 2
        return 0 if @p1_gwc == 2
      end
      return 1
    end

    # Returns the game points gained from "player".
    # @param player [Player]
    # @return [Integer]
    def game_points(player)
      ((@p1 == player ? @p1_gwc : @p2_gwc) * 3) + @gdc
    end

    # Returns the numer of games played.
    # @return [Integer]
    def games
      @p1_gwc + @p2_gwc + @gdc
    end

    # Returns the record for the match (Wins–Losses–Draws). Returns `nil` if
    # the match is not finished.
    # @return [String,nil]
    def record
      return nil? unless self.finished?

      return "#{@p1_gwc}-#{@p2_gwc}-#{@gdc}"
    end

    # Returns `true` if the match has finished. A match is considered finished
    # when the results have been recorded with {.result} method.
    # @return [Boolean]
    def finished?
      return !@p1_gwc.nil?
    end
  end
end
