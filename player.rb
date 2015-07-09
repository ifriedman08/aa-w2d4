class Player
  attr_accessor :game, :display, :color

  def initialize(game, display, color)
    @game = game
    @display = display
    @color = color
  end
end

class Human < Player

  def pick
    display.cursor_loop(:pick)
  end

  def multi_jump(first_pos)
    picked_pos = display.cursor_loop(:place, first_pos)
    picked_pos
    if picked_pos == :e
      raise ResetError.new
    else
      picked_pos
    end
  end

  def place(first_pos)
    picked_pos = display.cursor_loop(:place, first_pos)

    if picked_pos == :e
      raise ResetError.new
    else
      picked_pos
    end
  end

  def get_move
    begin
      first_pos = pick

      [first_pos, place(first_pos)]
    rescue ResetError => e
      retry
    end
  end
end


class ResetError < StandardError
end
