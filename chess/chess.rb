require_relative 'board'
require_relative 'display'
require_relative 'player'

class Chess
  def initialize(player1, player2)
    @current_player = player1
    @next_player = player2
    @board = Board.new
    @display = Display.new(@board)
    @current_player.display = @display
    @next_player.display = @display
  end

  def play
    until over?
      play_turn
      swap_turn
    end

    @display.render
    puts "Checkmate, mate."
    puts "#{@next_player.name} wins!"
  end

  def over?
    @board.checkmate?
  end

  def play_turn
    begin
      notify_players
      start, end_pos = @current_player.make_move
      @board.move!(start, end_pos)
      handle_pawn_promotion
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def handle_pawn_promotion
    promotable = @board.grid.flatten.select do |piece|
      piece.is_a?(Pawn) && (piece.pos[0] == 0 || piece.pos[0] == 7)
    end

    unless promotable.empty?
      promote(promotable.first)
    end
  end

  def promote(piece)
    puts "Please type the name of the piece you want to promote your pawn to?"
    answer = gets.chomp.downcase

    color = piece.color
    pos = piece.pos

    case answer
    when 'bishop'
      @board[pos] = Bishop.new(color, @board, pos)
    when 'knight'
      @board[pos] = Knight.new(color, @board, pos)
    when 'rook'
      @board[pos] = Rook.new(color, @board, pos)
    when 'easter egg'
      # seriously this is not a bug :D
      @board[pos] = King.new(color, @board, pos)
    else
      @board[pos] = Queen.new(color, @board, pos)
    end
  end

  def notify_players
    @display.render
    puts "It's #{@current_player.name}'s turn : "
  end

  def swap_turn
    @current_player, @next_player = @next_player, @current_player
  end

end

if __FILE__ == $PROGRAM_NAME
  caleb = HumanPlayer.new("Caleb", :white)
  can = HumanPlayer.new("Can", :black)
  g = Chess.new(caleb, can)
  g.play
end
