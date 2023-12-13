class Player
  attr_accessor :name ,:captured,:color

  def initialize(player,color)
    @name = player
    @color = color
    @captured = []
  end

end
