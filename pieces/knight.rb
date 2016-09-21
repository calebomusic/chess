require_relative 'stepping_piece'

class Knight < SteppingPiece
  def symbol
    @color == :white ? "\u{2658}" : "\u{265E}"
  end

  protected
  def move_diffs
      move_diffs = []
      [-2, 2].each do |long|
        [-1, 1].each do |short|
          diff = [long, short]
          move_diffs << diff

          diff = [short, long]
          move_diffs << diff
        end
      end
      move_diffs
  end
end
