require_relative 'piece'

class SteppingPiece < Piece
  def moves
    moves = []
    move_diffs.each do |move_diff|
      row, col = move_diff
      moves << [pos[0] + row, pos[1] + col]
    end

    moves.delete_if { |move| !on_board?(move) }
    moves.delete_if { |move| @board[move].color == color }
  end
end
