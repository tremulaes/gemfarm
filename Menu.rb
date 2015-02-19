require_relative 'MenuAction'
require_relative 'InterfaceSound'

CROP_MENU = [{ water: "Water"}, { dance: "Dance"}, { kick: "Kick" }]
EMPTY_FIELD_MENU = [{ plant_corn: "Plant Corn"}, { plant_pumpkin: "Plant Pumpkin"}, { plant_tomato: "Plant Tomato"}]
MAP_SCREEN_MENU = [{ energy: "Energy" }, { laugh: "Laugh" }, { warp: "Warp" }, { exit: "Exit"}]
WARP_CONFIRM_MENU = [{ warp_home: "Home"}, { warp_farm: "Farm"}, { warp_big: "Big Field"}]
EXIT_CONFIRM_MENU = [{ exit_yes: "Yes"}, exit_no: "No"]

class Menu
  include MenuAction
  attr_accessor :show, :cursor

  def initialize(window, message)
    @window, @message = window, message
    @font = Gosu::Font.new(@window, "Courier", 12)
    @items = MAP_SCREEN_MENU
    @menu_act_hash = {}
    @x, @y, @w, @h, @b = 0, 96, 0, 0, 5
    calc_dimen
    @black = 0xff000000 # black
    @white = 0xffffffff # white
    @cursor = 0
    @show = :false
    @action = :none
  end

  def update
    if @action != :none
      menu_act(@action, @menu_act_hash)
    end
  end

  def move_up
    if @cursor == 0
      @cursor = @items.size - 1
    else
      @cursor -= 1
    end
  end

  def move_down
    if @cursor == (@items.size - 1)
      @cursor = 0
    else
      @cursor += 1
    end
  end

  def interact
    action = @items[cursor].keys[0]
    if @action == :none
      @action = action
    end
  end

  def items=(array)
    @items = []
    array.each {|item_hash| @items << item_hash }
    @items << { cancel: "Cancel" }
    calc_menu_act_hash
    @cursor = 0
    calc_dimen
    @show = :true
  end

  def calc_dimen
    @h = @items.size * 52 + 10
    long = @items.max_by {|item| item.values[0].size }
    @w = long.values[0].size * 26 + 40
    @x = 656 - @w
  end

  def draw
    if @show == :true || @show == :continue
      @window.draw_quad(@x - @b, @y - @b, @black, @x + @w + @b, @y - @b, @black, @x - @b, @y + @h + @b, @black, @x + @w + @b, @y + @h + @b, @black, 4) #black box
      @window.draw_quad(@x, @y, @white, @x + @w, @y, @white, @x, @y + @h, @white, @x + @w, @y + @h, @white, 5) # white box
      @items.each_with_index do |hash, index|
        @font.draw("#{hash.values[0]}", @x + 30 , @y + 10 + (index * 52), 6, 4.0, 4.0, @black)
      end
      @window.draw_triangle(@x + 5, @cursor * 52 + 20 + @y, @black, @x + 5, @cursor * 52 + 40 + @y, @black, @x + 22, @cursor * 52 + 30 + @y, @black, 7) # cursor
    end
  end
end