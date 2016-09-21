require_relative 'sliding_piece'

class Queen < SlidingPiece
  def symbol
    @color == :white ? "\u{2655}" : "\u{265B}"
  end

  protected
  def move_dirs
    horizontal_dirs + diagonal_dirs
  end
end
