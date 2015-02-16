require_relative 'MenuAction'

CROP_MENU = [{ water: "Water"}, {laugh: "Laugh"}, {kick: "Kick"}]
EMPTY_FIELD_MENU = [{ plant: "Plant"}, {dance: "Dance"}]

class Menu
  attr_accessor :show, :cursor
  include MenuAction

  def initialize(window, message, menu_hash)
    @window, @message = window, message
    @items = menu_hash
    @menu_act_hash = {}
    @h = 0
    calc_height
    @x, @y = 480, 170
    @w = 300
    @b = 5
    @show = false
    @font = Gosu::Font.new(@window, "Courier", 15)
    @black = 0xff000000 # black
    @white = 0xffffffff # white
    @cursor = 0
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
    menu_act(action, @menu_act_hash)
  end

  def items=(array)
    @items = []
    array.each {|item_hash| @items << item_hash}
    @items << { cancel: "Cancel" }
    calc_menu_act_hash
    @cursor = 0
    calc_height
    @show = true
  end

  def calc_height
    @h =
      case @items.size
      when 1 then 74
      when 2 then 138
      when 3 then 202
      when 4 then 266
      when 5 then 330
      when 6 then 394
      end
  end

  def draw
    if @show
      @window.draw_quad(@x - @b, @y - @b, @black, @x + @w + @b, @y - @b, @black, @x - @b, @y + @h + @b, @black, @x + @w + @b, @y + @h + @b, @black, 4) #black box
      @window.draw_quad(@x, @y, @white, @x + @w, @y, @white, @x, @y + @h, @white, @x + @w, @y + @h, @white, 5) # white box
      @items.each_with_index do |hash, index|
        @font.draw("#{hash.values[0]}", @x + 30 , @y + 10 + (index * 64), 6, 4.0, 4.0, @black)
      end
      @window.draw_triangle(@x + 5, @cursor * 64 + 25 + @y, @black, @x + 5, @cursor * 64 + 45 + @y, @black, @x + 22, @cursor * 64 + 35 + @y, @black, 7) # cursor
    end
  end
end