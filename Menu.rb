require_relative 'MenuAction'

CROP_MENU = [{ water: "Water"}, {laugh: "Laugh"}]
EMPTY_FIELD_MENU = [{ plant: "Plant"}, {dance: "Dance"}]

class Menu
  attr_accessor :show, :cursor
  include MenuAction

  def initialize(window, menu_hash)
    @window = window
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

  def calc_menu_act_hash
    # puts "#menu_act_hash: {@menu_act_hash}"
    key_array = []
    @items.each {|item| key_array << item.keys[0]}
    # puts "key_array: #{key_array}"
    if key_array.include?(:water)
      @menu_act_hash[:crop] = @window.ruby.facing_tile.holding
    end
    if key_array.include?(:plant)
      @menu_act_hash[:tile] = @window.ruby.facing_tile
    end
  end

  def calc_height
    @h =
      case @items.size
      when 1 then 64
      when 2 then 128
      when 3 then 192
      when 4 then 256
      when 5 then 320
      when 6 then 384
      end
  end

  def draw
    if @show
      @window.draw_quad(@x - @b, @y - @b, @black, @x + @w + @b, @y - @b, @black, @x - @b, @y + @h + @b, @black, @x + @w + @b, @y + @h + @b, @black, 4)
      @window.draw_quad(@x, @y, @white, @x + @w, @y, @white, @x, @y + @h, @white, @x + @w, @y + @h, @white, 5)
      @items.each_with_index do |hash, index|
        @font.draw("#{hash.values[0]}", @x + 25 , @y + 5 + (index * 64), 6, 4.0, 4.0, @black)
        index += 1
      end
      @window.draw_triangle(@x + 5, @cursor * 64 + 20 + @y, @black, @x + 5, @cursor * 64 + 40 + @y, @black, @x + 22, @cursor * 64 + 30 + @y, @black, 7)
    end
  end
end