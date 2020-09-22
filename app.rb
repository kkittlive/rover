# frozen_string_literal: true

class App
  def initialize
    @plateau_size = []
    @rover_start_xy = []
    @results = []
    @continue = 'Y'
  end

  def execute
    puts '------------------------------------------------'
    puts "Welcome to jkwan's Mars Rover app."

    set_plateau_size
    while @continue == 'Y'
      set_start_xy
      set_route
      calculate_endpoint
      ask_to_continue
    end

    show_results
  end

  def set_plateau_size
    puts ''
    puts '--------'
    puts 'How many coordinates wide and tall would you like this plateau to be?'
    puts "(e.g. for 5 x 5, type '5 5' and hit enter)"
    print '> '

    @plateau_size = gets.chomp.split
    puts "Right on! So our plateau is #{@plateau_size[0]} wide (x-axis) by #{@plateau_size[1]} tall (y-axis)."
  end

  def set_start_xy
    puts ''
    puts '--------'
    puts 'Where on this plateau would you like your rover to be plopped, and facing which direction?'
    puts "You can enter any coordinates from '0 0 ' up to '#{@plateau_size[0]} #{@plateau_size[1]}',"
    puts "and you can specify the direction with either 'N', 'E', 'S', or 'W'."
    puts "So we'll want to enter something like: '1 2 N' or '3 3 E'."
    print '> '

    @rover_start_xy = gets.chomp.split.map! { |character| character =~ /\d/ ? character.to_i : character }
  end

  def set_route
    puts ''
    puts '--------'
    puts "Awesome. So starting from x = #{@rover_start_xy[0]} and y = #{@rover_start_xy[1]}, facing #{compass(@rover_start_xy[2])},"
    puts "what's the route we'd like this rover to navigate?"
    puts "We can type 'L' for the rover to turn left (rotate 90deg counter-clockwise, without otherwise moving),"
    puts "'R' to turn right, and 'M' to move forward one step (in the direction they're already facing)."
    puts "So we'll want to enter something like: 'LMLMLMLMM' or 'MMRMMRMRRM'."
    print '> '

    @rover_route = gets.chomp
  end

  def ask_to_continue
    puts ''
    puts '--------'
    puts "Would you like to plop another rover on this plateau? Enter 'Y' or 'N'"
    print '> '

    @continue = gets.chomp
  end

  def calculate_endpoint
    rover_current_xy = @rover_start_xy

    @rover_route.split('').each do |step|
      case step
      when 'L', 'R'
        rotate(rover_current_xy, step)
      when 'M'
        move(rover_current_xy)
      end
    end

    @results << rover_current_xy
  end

  def show_results
    puts ''
    puts '--------'
    puts 'Here are the resulting whereabouts of your rover(s):'
    @results.each do |result|
      puts result.join(' ')
    end
    puts 'Thanks for visiting Mars!'
    puts '------------------------------------------------'
  end

  def compass(letter)
    case letter
    when 'N'
      'North'
    when 'E'
      'East'
    when 'S'
      'South'
    when 'W'
      'West'
    end
  end

  def rotate(rover_current_xy, change)
    directions = %w[N E S W]
    position = directions.index(rover_current_xy[2])

    if change == 'L'
      rover_current_xy[2] = directions.rotate!(-1)[position]
    elsif change == 'R'
      rover_current_xy[2] = directions.rotate(1)[position]
    end
  end

  def move(rover_current_xy)
    case rover_current_xy[2]
    when 'N'
      rover_current_xy[1] += 1
    when 'E'
      rover_current_xy[0] += 1
    when 'S'
      rover_current_xy[1] -= 1
    when 'W'
      rover_current_xy[0] -= 1
    end
  end
end

app = App.new
app.execute
