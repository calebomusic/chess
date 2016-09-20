require 'colorize'

class Piece
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @board[pos] = self
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

class SteppingPiece < Piece
  def moves
    moves = []
    move_diffs.each do |move_diff|
      row, col = move_diff
      moves << [pos[0] + row, pos[1] + col]
    end

    moves.delete_if { |move| !on_board?(move) }
  end
end

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

    until !on_board?([x, y]) && @board[[x,y]].is_a?(Piece)
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

class Queen < SlidingPiece
  def symbol
    @color == :white ? "\u{2655}" : "\u{265B}"
  end

  protected
  def move_dirs
    horizontal_dirs + diagonal_dirs
  end
end

class Bishop < SlidingPiece
  def symbol
    @color == :white ? "\u{2657}" : "\u{265D}"
  end

  protected
  def move_dirs
    diagonal_dirs
  end
end

class Rook < SlidingPiece
  def symbol
    @color == :white ? "\u{2656}" : "\u{265C}"
  end

  protected
  def move_dirs
    horizontal_dirs
  end
end

class Pawn < Piece
  def symbol
    @color == :white ? "\u{2659}" : "\u{265F}"
  end

  def moves
    moves = []

    forward_steps.each do |step|
      pos = @pos.map.with_index { |el, i| el + step[i] }
      if on_board?(pos) && @board[pos].empty?
        moves << pos
      end
    end

    side_attacks.each do |step|
      pos = @pos.map.with_index { |el, i| el + step[i] }
      if on_board?(pos) && @board[pos].color != @color
        moves << pos
      end
    end

    moves
  end

  protected
  def at_start_row?
    if @color == :black && @pos[0] == 1
      true
    elsif @color == :white && @pos[0] == 6
      true
    else
      false
    end
  end

  def forward_dir
    if @color == :black
      [1, 0]
    else
      [-1, 0]
    end
  end

  def forward_steps
    moves = [forward_dir]
    moves << [forward_dir[0] * 2, 0] if at_start_row?
  end

  def side_attacks
    x, y = forward_dir
    [[x, y + 1], [x, y -1]]
  end
end
