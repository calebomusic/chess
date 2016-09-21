require_relative 'sliding_piece'

class Rook < SlidingPiece
  def symbol
    @color == :white ? "\u{2656}" : "\u{265C}"
  end

  protected
  def move_dirs
    horizontal_dirs
  end
end
