require 'pry'
require 'debugger'
class Sudoku
  
  attr_reader :board

  def initialize(board_string)
    @board = Board.new(board_string)
  end

  def solve!
    while @board.board_map.flatten.any? {|cell| cell == 0}
      puts board
      fill_cells
    end
  end
  
  def fill_cells
    @board.board_map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell == 0
          @board.board_map[y][x] = final_value(x , y) 
        end
      end
    end
  end

  def final_value(x_coord, y_coord)
    possibles =[]
    (1..9).each do |number|
      possibles << number if not_in_row?(number, y_coord) && not_in_column?(number, x_coord) && not_in_box?(number, x_coord, y_coord)
    end
    if possibles.length == 1
      puts "just placed #{possibles.first}"
      return possibles.first 
    end
    0
  end

  def not_in_row?(number, row)
    !@board.board_map[row].include?(number)
  end

  def not_in_column?(number, column)
    @board.board_map.none? { |row| row[column] == number }
  end

  def not_in_box?(number, x, y)
    starting_x = (x/3) * 3 
    starting_y = (y/3) * 3
    (starting_y..starting_y +2).all? do |y_coord|
      (starting_x..starting_x+2).none? do |x_coord|
        @board.board_map[y_coord][x_coord] == number
      end
    end
  end

  def print_board
    return @board.to_s
  
  end
end

class Board
  attr_accessor :board_map
  def initialize(board_string)
    @board_map = board_string.split('').each_slice(9).to_a
    @board_map.map! { |row| row.map(&:to_i) }
  end

  def to_s
    puts ''
    @board_map.each do |row|
      puts row.join(' | ')
      puts "\n__________________________________"
    end
  end
  
end

board_string = File.readlines('sample.unsolved.txt')[1].chomp

game = Sudoku.new(board_string)


# Remember: this will just fill out what it can and not "guess"
game.solve!

puts game.board
