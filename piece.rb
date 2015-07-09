require 'colorize'
require 'byebug'

class Piece

  attr_reader :color, :board
  attr_accessor :pos, :kinged

  RED_DIRECTIONS = [
    [-1, 1],
    [-1, -1]
  ]

  BLUE_DIRECTIONS = [
    [1, 1],
    [1, -1]
  ]

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @kinged  = false
    @color = color
  end

  def occupied?
    true
  end

  def move!(new_pos)
    self.pos = new_pos
    if promotable?
      # byebug
      promote!
    end
  end

  def promote!
    self.kinged = true if promotable?
  end

  def promotable?
    (color == :blue && pos[0] == 0) || (color == :red && pos[0] == 7)
  end

  def to_s
    if kinged
      ' ☻ '.colorize(self.color == :red ? :red : :blue)
    else
      ' ☺ '.colorize(self.color == :red ? :red : :blue)
    end
  end

  def valid_moves
    valid_steps + valid_jumps
  end

  def opponent_color
    color == :red ? :blue : :red
  end

  def valid_steps
    if kinged == true
      dirs = RED_DIRECTIONS + BLUE_DIRECTIONS
    else
      dirs = color == :red ? BLUE_DIRECTIONS : RED_DIRECTIONS
    end

    all_steps = dirs.map do |direction|
      new_pos = [pos[0] + direction[0], pos[1] + direction[1]]
    end

    all_steps.select do |new_pos|
      board.on_board?(new_pos) && board.unoccupied?(new_pos)
    end
  end

  def valid_jumps
    if kinged == true
      dirs = RED_DIRECTIONS + BLUE_DIRECTIONS
    else
      dirs = color == :red ? BLUE_DIRECTIONS : RED_DIRECTIONS
    end

    result = []
    all_jumps = dirs.each do |direction|
      next_pos = [pos[0] + direction[0], pos[1] + direction[1]]
      next unless board.on_board?(next_pos)
      if board[next_pos].color == opponent_color
        result << [pos[0] + (2 * direction[0]), pos[1] + (2 * direction[1])]
      end
    end

    true_jumps = result.select do |new_pos|
      board.on_board?(new_pos) && board.unoccupied?(new_pos)
    end
  end

  def can_jump?
    !valid_jumps.empty?
  end

  def step(new_pos)
  end
end

class EmptySpace < Piece
  def initialize
    @color = :none
  end

  def occupied?
    false
  end

  def to_s
    '   '
  end

  def valid_moves
    []
  end

  def moves
    []
  end

  def move
  end

  def color
    :none
  end

  def dup(new_board)
    self
  end
end
