require_relative 'display'
require_relative 'player'
require 'yaml'

class Game
  attr_accessor :board, :display, :players

  def initialize
    @board = Board.new
    @display = Display.new(board, self)
    @players = pick_mode
    run
  end

  def grid
    board.grid
  end

  def pick_mode
    display.display_modes
    mode = gets.chomp
    case mode
    when "1"
      [Human.new(self, display, :blue), Human.new(self, display, :red)]
    when "2"
      [Human.new(self, display, :blue), Computer.new(self, display, :red)]
    when "3"
      [Computer.new(self, display, :blue), Computer.new(self, display, :red)]
    when "4"
      ChessGame.load_file
    end
  end

  def setup_pieces
    board.populate_board
  end

  def self.load_file
    puts "Which file would you like to load?"
    filename = gets.chomp
    loaded_game = File.open(filename, "r") { |f| YAML::load(f) }
    loaded_game.run
  end

  def save
    puts "What filename would you like to use for this save?"
    filename = gets.chomp
    File.open(filename, "w") { |f| f.write(self.to_yaml) }
  end

  def current_player
    players.first
  end

  def current_color
    current_player.color
  end

  def run
    turn until game_over?
    display.game_over_message
  end

  def turn
    move = current_player.get_move
    execute_move(move)
    switch_turn
  end

  def move_type(move)
    if (move[0][0] - move[1][0]).abs == 2
      :jump
    else
      :step
    end
  end

  def execute_move(move)
    board.execute_move(move)
    if move_type(move) == :jump && board[move[1]].can_jump?
      execute_move([move[1], board[move[1]].valid_jumps.first])
    end
  end

  def switch_turn
    players.rotate!
  end

  def pieces_left
    grid.flatten.reject {|piece| piece.color == :none}
  end

  def game_over?
    pieces_left.none? {|piece| byebug if piece.class == Fixnum; piece.color == :red } ||
    pieces_left.none? {|piece| byebug if piece.class == Fixnum; piece.color == :blue }
  end
end

g = Game.new
b = g.board
g.setup_pieces
d = Display.new(b, g)
d.render
