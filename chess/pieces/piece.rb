require 'colorize'

class Piece
  attr_reader :color
  attr_accessor :board, :pos, :prev_pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @board[pos] = self
    @prev_pos = pos
  end

  def to_s
    symbol
  end

  def symbol
  end

  def moves
  end

  def empty?
    false
  end

  def update_pos(new_pos)
    @prev_pos = @pos
    @pos = new_pos
  end

  def valid_move?(end_pos)
    valid_moves.include?(end_pos)
  end

  def valid_moves
    valid_moves = []
    moves.each do |end_pos|
      unless @board.move(@pos, end_pos).in_check?(@color)
        valid_moves << end_pos
      end
    end

    valid_moves
  end


  def move_into_check?(to_pos)
    @board.move(@pos, to_pos).in_check?(@color)
  end

  def on_board?(pos)
    x, y = pos
    return true if x.between?(0, 7) && y.between?(0, 7)
    false
  end
end
