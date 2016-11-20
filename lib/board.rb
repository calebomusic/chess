require 'require_all'
require_all "pieces/"

class Board
  attr_reader :grid, :log

  def self.empty_grid
    Board.new(Array.new(8) { Array.new(8) })
  end

  def initialize(grid = nil)
    if grid
      @grid = grid
    else
      default_grid
    end
    @log = []
  end

  def default_grid
    @grid = Array.new(8) { Array.new(8) }
    configure_grid
  end

  def configure_grid
    set_base_row(0, :black)
    set_pawn_row(1, :black)

    (2..5).each do |row|
      nullpiece_row(row)
    end

    set_pawn_row(6, :white)
    set_base_row(7, :white)
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def length
    @grid.length
  end

  def move!(start, end_pos)
    handle_en_passant(self[start], start, end_pos)
    self[end_pos] = self[start]
    self[end_pos].update_pos(end_pos)
    self[start] = NullPiece.instance
    @log << [ self[end_pos], start, end_pos ]
    self
  end

  def handle_en_passant(piece, start, end_pos)
    if piece.is_a?(Pawn) && start[1] != end_pos[1] && self[end_pos].is_a?(NullPiece)
      pos = [start[0], end_pos[1]]
      self[pos] = NullPiece.instance
    end
  end

  def move(start, end_pos)
    dup.move!(start, end_pos)
  end

  def dup
    new_board = Board.empty_grid
    @grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        new_piece = piece.dup
        new_board[[i,j]] = new_piece

        next if piece.is_a?(NullPiece)
        new_piece.board = new_board
        new_piece.pos = piece.pos.dup
        new_piece.prev_pos = piece.prev_pos.dup
      end
    end

    new_board
  end

  def checkmate?
    checkmate_color?(:white) || checkmate_color?(:black)
  end

  def in_check?(color)
    king = find_king(color)
    @grid.each do |row|
      row.each do |piece|
        unless piece.color == color
          if piece.moves.include?(king.pos)
            return true
          end
        end
      end
    end
    false
  end

  def checkmate_color?(color)
    @grid.flatten.each do |piece|
      # next if piece.is_a?(NullPiece)
      if piece.color == color && !piece.valid_moves.empty?
        return false
      end
    end

    true
  end

  protected
  def find_king(color)
    @grid.flatten.each do |piece|
      return piece if piece.is_a?(King) && piece.color == color
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
    @grid[row_number] = @grid[row_number].map { |piece| NullPiece.instance }

    # @grid[row_number].each do |space|
    #   space = NullPiece.instance
    # end
  end
end
