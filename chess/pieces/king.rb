require_relative 'stepping_piece'

class King < SteppingPiece
  def symbol
    @color == :white ? "\u{2654}" : "\u{265A}"
  end

  protected
  def move_diffs
    move_diffs = []
    (-1..1).each do |horizontal|
      (-1..1).each do |vertical|
        diff = [horizontal, vertical]
        next if diff == [0, 0]
        move_diffs << diff
      end
    end
    move_diffs
  end
end
