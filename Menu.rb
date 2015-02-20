# require_relative 'MenuAction'
require_relative 'Message'
require_relative 'SubMenu'

class Menu
  # include MenuAction
  attr_accessor :show, :cursor, :mode

  def initialize(window, player, current_list)
    @window, @player = window, player
    @message = Message.new(@window, self)
    @params = {}
    calc_menu
    @font = Gosu::Font.new(@window, "Courier", 12)
    @current_list = current_list
    @print_list = []
    calc_print_list
    @mode = :select # :select, :message, :sub_menu1, :sub_menu2
    @x, @y, @w, @h, @b = 0, 96, 0, 0, 5
    calc_dimen
    @black = 0xff000000 # black
    @white = 0xffffffff # white
    @cursor = 0
    make_sub_menu
  end

  def make_sub_menu
    @sub_menu1 = SubMenu.new(@window, self, @player, @message, @font, [606, 146], 8)
    @sub_menu2 = SubMenu.new(@window, self, @player, @message, @font, [556, 196], 9)
  end

  def use_sub_menu(menu, list)
    if menu == :sub_menu1
      @sub_menu1.current_list = list
      @message.current_menu = @sub_menu1
    elsif menu == :sub_menu2
      @sub_menu2.current_list = list
      @message.current_menu = @sub_menu2
    end
    @mode = menu
  end

  def current_list=(new_list)
    if @current_list != new_list
      @current_list = new_list
      @cursor = 0
      @sub_menu1.cursor = 0
      @sub_menu2.cursor = 0
    end
    calc_print_list
    calc_dimen
  end

  def show_message(text)
    @message.set_text(text)
    @mode = :message_only
  end

  def calc_print_list
    @print_list.clear
    @current_list.each do |hash| ################## CHANGES
      @print_list << hash[:print]
    end
  end

  def move_up
    case @mode
    when :sub_menu1 then @sub_menu1.move_up
    when :sub_menu2 then @sub_menu2.move_up
    else @cursor == 0 ? @cursor = @print_list.size - 1 : @cursor -= 1
    end
  end

  def move_down
    case @mode
    when :sub_menu1 then @sub_menu1.move_down
    when :sub_menu2 then @sub_menu2.move_down
    else @cursor == (@print_list.size - 1) ? @cursor = 0 : @cursor += 1
    end
  end

  def interact
    case @mode
    when :message then @message.interact
    when :sub_menu1 then @sub_menu1.interact
    when :sub_menu2 then @sub_menu2.interact
    when :message_only then @message.interact
    else 
      calc_menu
      @current_list[@cursor][:block].call(@params)
    end
  end

  def close
    @mode = :select
    @sub_menu1.mode = :select
    @sub_menu2.mode = :select
    @message.current_menu = self
    @message.close
    @window.mode = :field
  end

  def calc_menu
    @params.clear
    @params = {
      window: @window,
      menu: self,
      message: @message,
      player: @player
    }
  end

  def calc_dimen
    @h = @print_list.size * 52 + 10
    long = @print_list.max_by {|item| item.size } 
    @w = long.size * 20 + 50
    @x = 656 - @w
  end

  def draw
    if @mode != :message_only
      @window.draw_quad(@x - @b, @y - @b, @black, @x + @w + @b, @y - @b, @black, @x - @b, @y + @h + @b, @black, @x + @w + @b, @y + @h + @b, @black, 4) #black box
      @window.draw_quad(@x, @y, @white, @x + @w, @y, @white, @x, @y + @h, @white, @x + @w, @y + @h, @white, 5) # white box
      @print_list.each_with_index do |text, index|
        @font.draw("#{text}", @x + 30 , @y + 10 + (index * 52), 6, 4.0, 4.0, @black)
      end
      @window.draw_triangle(@x + 5, @cursor * 52 + 20 + @y, @black, @x + 5, @cursor * 52 + 40 + @y, @black, @x + 22, @cursor * 52 + 30 + @y, @black, 7) # cursor
    end
    @message.draw
    case @mode
    when :sub_menu1 then @sub_menu1.draw
    when :sub_menu2 then @sub_menu1.draw; @sub_menu2.draw
    end
  end
end
