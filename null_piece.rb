require 'singleton'
require 'colorize'

class NullPiece
  include Singleton

  def moves
  end

  def color
  end

  def to_s
    "\u{25A2}".black
  end

  def empty?
    true
  end
end
