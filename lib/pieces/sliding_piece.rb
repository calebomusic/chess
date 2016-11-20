require_relative 'piece'

class SlidingPiece < Piece
  def moves
    moves = []
    move_dirs.each do |dir|
      dx, dy = dir
      moves += grow_unblocked_moves_in_dir(dx, dy)
    end

    moves
  end

  private
  def move_dirs
  end

  def horizontal_dirs
    [[0,1], [0, -1], [1,0], [-1, 0]]
  end

  def diagonal_dirs
    [[1,1], [-1, 1], [1, -1], [-1, -1]]
  end

  def grow_unblocked_moves_in_dir(dx, dy)
    x, y = @pos
    moves = []

    x += dx
    y += dy

    until !on_board?([x, y]) || @board[[x,y]].is_a?(Piece)
      moves << [x,y]
      x += dx
      y += dy
    end

    if on_board?([x,y]) && @board[[x,y]].color != @color
      moves << [x,y]
    end

    moves
  end
end
