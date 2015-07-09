require_relative 'piece'

class Board

  attr_accessor :grid

  def blank_grid
    Array.new(8) { Array.new(8) { EmptySpace.new }}
  end

  def initialize(grid = blank_grid ,duped = false)
    @grid = grid
    populate_board unless duped
  end

  def populate_board
    (0..7).each do |row_idx|
      (0..7).each do |col_idx|
        if row_idx.between?(0,2) && (row_idx + col_idx).odd?
          self[[row_idx, col_idx]] = Piece.new(self, [row_idx, col_idx], :red)
        elsif row_idx.between?(5,7) && (row_idx + col_idx).odd?
          self[[row_idx, col_idx]] = Piece.new(self, [row_idx, col_idx], :blue)
        else
        end
      end
    end
  end

  def [](pos)
    row, col = pos
    byebug if row.nil? || col.nil?
    grid[row][col]
  end

  def []=(pos, new_piece)
    row, col = pos
    grid[row][col] = new_piece
  end

  def unoccupied?(pos)
    !occupied?(pos)
  end

  def occupied?(pos)
    self[pos].occupied?
  end

  def execute_move(move)
    start_pos = move[0]
    end_pos = move[1]
    num_squares = end_pos[0] - start_pos[0]
    move_piece(move)
    if num_squares.abs == 2
      jumped_pos = [(start_pos[0] + end_pos[0]) / 2, (start_pos[1] + end_pos[1]) / 2]
      self[jumped_pos] = EmptySpace.new
    end
  end

  def deep_dup(array)
    array.map do |el|
      return el.dup unless el.class == Array
      deep_dup(el)
    end
  end

  def dup
    Board.new(deep_dup(self.grid), true)
  end

  def move_piece(move)
    move.flatten.length != move.length
    start_pos = move[0]
    end_pos = move[1]
    self[start_pos].move!(end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = EmptySpace.new
  end

  def opponent_pieces(color)
    grid.flatten.select do |piece|
      piece.color == opponent_color(color)
    end
  end

  def opponent_color(color)
    color == :red ? :blue : :red
  end

  def blocked?(pos)
    !on_board?(pos) || occupied?(pos)
  end

  def on_board?(pos)
    (0...8).include?(pos[0]) && (0...8).include?(pos[1])
  end

end
