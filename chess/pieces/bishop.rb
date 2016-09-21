require_relative 'sliding_piece'

class Bishop < SlidingPiece
  def symbol
    @color == :white ? "\u{2657}" : "\u{265D}"
  end

  protected
  def move_dirs
    diagonal_dirs
  end
end
