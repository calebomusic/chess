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
    rescue RuntimeError => e
      puts e.message
      retry
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
