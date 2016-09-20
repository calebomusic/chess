require_relative 'cursor'
require_relative 'board'
require 'colorize'
class Display
  attr_reader :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], @board)
  end

  def render
    system('clear')
    puts "    " + ('a'..'h').to_a.join("   ")
    draw_horiz_line

    @board.grid.each_with_index do |row, i|
      row_str = "#{i+1} |"
      row.each_with_index do |piece, j|
        if @cursor.cursor_pos == [i, j]
          row_str << " #{piece} ".cyan << "|"
        else
          row_str << " #{piece} |"
        end
      end
      puts row_str
      draw_horiz_line
    end
  end

  def draw_horiz_line
    puts "----" * (@board.length + 1)
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  d = Display.new(b)
  while true
    d.render
    d.cursor.get_input
  end
end
