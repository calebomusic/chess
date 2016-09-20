require_relative 'cursor'
require_relative 'board'
require 'colorize'
class Display
  attr_reader :cursor
  attr_accessor :board
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], @board)
  end

  def render
    system('clear')
    puts "    " + ('a'..'h').to_a.join("   ")
    draw_horiz_line

    @board.grid.each_with_index do |row, i|
      row_str = "#{8 - i} |"
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

    puts "Check, mate!" if @board.in_check?(:black) || @board.in_check?(:white)
  end

  def draw_horiz_line
    puts "----" * (@board.length + 1)
  end
end
