require_relative 'piece'

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
      if on_board?(pos) && @board[pos].is_a?(Piece) && @board[pos].color != @color
        moves << pos
      end
    end

    moves.concat(en_passant)
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
    moves
  end

  def side_attacks
    x, y = forward_dir
    [[x, y + 1], [x, y -1]]
  end

  def made_start_jump?
    (@pos[0] - @prev_pos[0]).abs == 2
  end

  def en_passant
    row, col = @pos
    moves = []

    last_piece = @board.log.last[0] unless @board.log.empty?

    if last_piece.is_a?(Pawn) && last_piece.made_start_jump? && neighbors.include?(last_piece)
      moves << [last_piece.pos[0] + forward_dir[0], last_piece.pos[1]]
    end

    moves
  end

  def neighbors
    row, col = @pos
    pieces = []
    [-1, 1].each do |diff|
      diff += col
      next unless diff.between?(0, 7)
      pieces << @board[[row, diff]]
    end
    pieces
  end
end
