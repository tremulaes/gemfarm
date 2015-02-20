class SubMenu
  include MenuAction
  attr_accessor :show, :cursor, :mode

  def initialize(window, menu, player, message, font, coords, zOrder)
    @window, @menu, @player = window, menu, player
    @message = message
    calc_menu
    @font = font
    @current_list = :map_menu
    @print_list = []
    calc_print_list
    @mode = :select # :select, :message
    @coords = coords
    @x, @y, @w, @h, @b, @z = 0, @coords[1], 0, 0, 5, zOrder
    calc_dimen
    @black = 0xff000000 # black
    @white = 0xffffffff # white
    @cursor = 0
  end

  def current_list=(new_list)
    if @current_list != new_list
      @current_list = new_list
      @cursor = 0
    end
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

  def close
    @menu.close
  end

  def calc_dimen
    @h = @print_list.size * 52 + 10
    long = @print_list.max_by {|item| item.size }
    @w = long.size * 20 + 50
    @x = @coords[0] - @w
  end

  def draw
    @window.draw_quad(@x - @b, @y - @b, @black, @x + @w + @b, @y - @b, @black, @x - @b, @y + @h + @b, @black, @x + @w + @b, @y + @h + @b, @black, @z) #black box
    @window.draw_quad(@x, @y, @white, @x + @w, @y, @white, @x, @y + @h, @white, @x + @w, @y + @h, @white, @z + 1) # white box
    @print_list.each_with_index do |text, index|
      @font.draw("#{text}", @x + 30 , @y + 10 + (index * 52), @z + 2, 4.0, 4.0, @black)
    end
    @window.draw_triangle(@x + 5, @cursor * 52 + 20 + @y, @black, @x + 5, @cursor * 52 + 40 + @y, @black, @x + 22, @cursor * 52 + 30 + @y, @black, @z + 3) # cursor
    @message.draw
  end

end