module Swiss
  # Class that rappresent a player in the swiss tournament.
  class Player
    # The player identifier.
    # @return [String]
    attr_reader :name

    # List of opponents for the whole tournament.
    # @return [Array<Player>]
    attr_reader :opponents

    # List of all matches for the whole tournament.
    # @return [Array<Match>]
    attr_reader :matches

    # Match Points. Players earn 3 match points for each match win, 0 points
    # for each match loss and 1 match point for each match ending in a draw.
    # Players receiving byes are considered to have won the match 2-0-0.
    #
    # - A player's record is 6–2–0 (Wins–Losses–Draws). That player has 18 match points (6*3, 2*0, 0*1).
    # - A player's record is 4–2–2. That player has 14 match points (4*3, 2*0,
    #   2*1).
    # @return [Integer]
    # @see https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf Magic the Gathering Tournament Rules
    attr_accessor :mp

    # Similar to the match-win percentage, a player's game-win percentage is
    # the total number of game points they earned divided by the total game
    # points possible (generally, 3 times the number of games played). Again,
    # use 0.33 if the actual game-win percentage is lower than that.
    # @return [Float]
    # @see https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf Magic the Gathering Tournament Rules
    attr_accessor :gw

    # Similar to opponents' match-win percentage, a player's opponents'
    # game-win percentage is simply the average game-win percentage of all
    # that player's opponents. And, as with opponents' match-win percentage,
    # each opponent has a minimum game-win percentage of 0.33.
    # @return [Float]
    # @see https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf Magic the Gathering Tournament Rules
    attr_accessor :ogw

    # Match Win Percentage. A player's match-win percentage is that player's
    # accumulated match points divided by the total match points possible in
    # those rounds (generally, 3 times the number of rounds played). If this
    # number is lower than 0.33, use 0.33 instead. The minimum match-win
    # percentage of 0.33 limits the effect low performances have when
    # calculating and comparing opponents' match-win percentage.
    # @return [Float]
    # @see https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf Magic the Gathering Tournament Rules
    attr_accessor :mw

    # A player's opponents' match-win percentage is the average match-win
    # percentage of each opponent that player faced (ignoring those rounds
    # for which the player received a bye). Use the match-win percentage
    # definition listed above when calculating each individual opponent's
    # match-win percentage.
    # @return [Float]
    # @see https://media.wizards.com/2023/wpn/marketing_materials/wpn/mtg_mtr_2023may29_en.pdf Magic the Gathering Tournament Rules
    attr_accessor :omw

    # Player has dropped.
    # @return [Boolean]
    attr_accessor :drop

    # Create a new player.
    # @param name [String] The name of the player.
    def initialize(name)
      @name = name
      @opponents = []
      @matches = []

      @mp = 0
      @gp = 0
      @gw = 33.33
      @ogw = 33.33
      @mw = 33.33
      @omw = 33.33

      @drop = false
    end

    # Print a player with stats.
    # @return [String]
    def to_s
      rows = []
      rows << self.name
      rows << "  mp: #{self.mp}"
      rows << " omw: #{self.omw}"
      rows << "  gw: #{self.gw}"
      rows << " ogw: #{self.ogw}"
      rows << "  mw: #{self.mw}"
      return rows.join("\n")
    end

    # Returns `true` if player has dropped.
    # @return [Boolean]
    def dropped?
      @drop
    end

    # Compare two players for sort the standings. The following tiebreakers
    # are used to determine how a player ranks in a tournament:
    #
    # 1. Match points
    # 2. Opponents' match-win percentage
    # 3. Game-win percentage
    # 4. Opponents' game-win percentage
    # @return [-1,0,1]
    def <=>(other)
      return -1 if self.mp > other.mp
      return 1 if self.mp < other.mp
      return -1 if self.omw > other.omw
      return 1 if self.omw < other.omw
      return -1 if self.gw > other.gw
      return 1 if self.gw < other.gw
      return -1 if self.ogw > other.gw
      return 1 if self.ogw < other.gw

      return 0
    end
  end
end
