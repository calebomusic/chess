require "byebug"
class Player
  attr_reader :name, :color
  attr_accessor :display
  def initialize(name, color)
    @name = name
    @color = color
  end

  def own_piece?(start_pos)
    piece = @display.board[start_pos]
    raise "Can only move own piece!" unless piece.color == @color
  end

  def same_pos?(start_pos, end_pos)
    raise "Same position!" if start_pos == end_pos
  end

  def valid_move?(start_pos, end_pos)
    raise "Invalid move!" unless @display.board[start_pos].valid_move?(end_pos)
  end

end

class HumanPlayer < Player
  def make_move
    start_pos = get_pos
    end_pos = get_pos

    own_piece?(start_pos)
    same_pos?(start_pos, end_pos)
    valid_move?(start_pos, end_pos)

    [start_pos, end_pos]
  end

  def get_pos
    pos = nil

    until pos == :select
      pos = @display.cursor.get_input
      @display.render
    end

    pos = @display.cursor.cursor_pos
  end

end
