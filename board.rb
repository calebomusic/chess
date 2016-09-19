class Board

  def self.empty_grid
    Board.new(Array.new(8) { Array.new(8) })
  end

  def initialize(grid = nil)
    if grid
      @grid = grid
    else
      default_grid
    end
  end

  def default_grid
    @grid = Array.new(8) { Array.new(8) }
    configure_grid
  end

  def configure_grid
    set_base_row(:black, self, 0)
    set_pawn_row(:black, self, 1)

    (2..5).each do |row|
      nullpiece_row(row)
    end

    set_pawn_row(:white, self, 6)
    set_base_row(:white, self, 7)
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def move!(start, end_pos)
    self[end_pos] = self[start]
    self[start] = NullPiece.new
  end

  def move(start, end_pos)
    duped_board = dup
    dup.move!(start, end_pos)
  end

  def dup
    new_board = Board.empty_grid
    @grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        new_piece = piece.dup
        new_piece.board = new_board
        new_board[[i,j]] = new_piece
      end
    end
  end

  private
  def set_base_row(row_number, color)
    Rook.new(color, self, [row_number, 0])
    Knight.new(color, self, [row_number, 1])
    Bishop.new(color, self, [row_number, 2])
    Queen.new(color, self, [row_number, 3])
    King.new(color, self, [row_number, 4])
    Bishop.new(color, self, [row_number, 5])
    Knight.new(color, self, [row_number, 6])
    Rook.new(color, self, [row_number, 7])
  end

  def set_pawn_row(row_number, color)
    (0..7).each do |i|
      Pawn.new(color, self, [row_number, i])
    end
  end

  def nullpiece_row(row_number)
    @grid[row_number].each do |space|
      space = NullPiece.new
    end
  end
end
