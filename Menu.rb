require_relative 'MenuAction'
require_relative 'InterfaceSound'

# PLANT_MENU = [{ water: "Water"}, { dance: "Dance"}, { kick: "Kick" }]
# EMPTY_FIELD_MENU = [{ plant_corn: "Plant Corn"}, { plant_pumpkin: "Plant Pumpkin"}, { plant_tomato: "Plant Tomato"}]
# MAP_SCREEN_MENU = [{ energy: "Energy" }, { laugh: "Laugh" }, { warp: "Warp" }, { exit: "Exit"}]
# EXIT_CONFIRM_MENU = [{ exit_yes: "Yes"}, exit_no: "No"]

class Menu
  include MenuAction
  attr_accessor :show, :cursor, :mode

  def initialize(window, player)
    @window, @player = window, player
    @message = Message.new(@window, self)
    calc_menu
    @font = Gosu::Font.new(@window, "Courier", 12)
    @current_list = :map_menu
    @print_list = []
    calc_print_list
    @mode = :select # :select, :message
    @x, @y, @w, @h, @b = 0, 96, 0, 0, 5
    calc_dimen
    @black = 0xff000000 # black
    @white = 0xffffffff # white
    @cursor = 0
  end

  def current_list=(new_list)
    puts "#{@current_list}: #{new_list}"
    @current_list = new_list
    calc_print_list
    calc_dimen
  end

  def calc_print_list
    @print_list.clear
    @menus[@current_list].each do |hash|
      @print_list << hash[:print]
    end
  end

  def move_up
    if @cursor == 0
      @cursor = @print_list.size - 1
    else
      @cursor -= 1
    end
  end

  def move_down
    if @cursor == (@print_list.size - 1)
      @cursor = 0
    else
      @cursor += 1
    end
  end

  def interact
    if @mode == :message
      @message.interact
    else 
      calc_menu
      @menus[@current_list][@cursor][:block].call(@menus[@current_list][@cursor][:params])
    end
  end

  def calc_dimen
    @h = @print_list.size * 52 + 10
    long = @print_list.max_by {|item| item.size }
    @w = long.size * 20 + 50
    @x = 656 - @w
  end

  def draw
    @window.draw_quad(@x - @b, @y - @b, @black, @x + @w + @b, @y - @b, @black, @x - @b, @y + @h + @b, @black, @x + @w + @b, @y + @h + @b, @black, 4) #black box
    @window.draw_quad(@x, @y, @white, @x + @w, @y, @white, @x, @y + @h, @white, @x + @w, @y + @h, @white, 5) # white box
    @print_list.each_with_index do |text, index|
      @font.draw("#{text}", @x + 30 , @y + 10 + (index * 52), 6, 4.0, 4.0, @black)
    end
    @window.draw_triangle(@x + 5, @cursor * 52 + 20 + @y, @black, @x + 5, @cursor * 52 + 40 + @y, @black, @x + 22, @cursor * 52 + 30 + @y, @black, 7) # cursor
    @message.draw
  end
end
