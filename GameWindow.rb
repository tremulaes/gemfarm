# @maps is a hash; key = map name, value is an array with relevant data
# array[0] = map object with initialize conditions
# array[1] = default warp coordinates [x,y] format

require 'gosu'
require_relative 'Bed'
require_relative 'Calendar'
require_relative 'Camera'
require_relative 'Crop'
require_relative 'SapphireCorn'
require_relative 'AmethystTomato'
require_relative 'EmeraldPumpkin'
require_relative 'Map'
require_relative 'Menu'
require_relative 'Player'
require_relative 'Sound'
require_relative 'Warp'
require_relative 'TextEvent'
require_relative 'Title'
require_relative 'Timer'

class GameWindow < Gosu::Window
  attr_reader :map, :player, :timer, :calendar, :sounds
  attr_accessor :mode, :menu

  def initialize
    super(704, 704, false)
    self.caption = 'Gem Farm'
    @title = Title.new(self)
    generate_maps
    @map = @maps[:home][0]
    @sounds = Sound.new(self)
    @player = Player.new(self, @map)
    @player.warp(4,5,:down)
    @map.calc_show_tiles(@player.x,@player.y)
    @calendar = Calendar.new(self)
    calc_menu
    @menu = Menu.new(self, @player, @window_menu)
    @camera = Camera.new(self, @map)
    @timer = Timer.new
    @queue = []
    @action
    @mode = :title # :title, :field, :message, :menu
  end

  def update
    @timer.update
    @sounds.update
    calc_viewport
    case @mode
    when :title then @title.update  
    else 
      @action = @queue.shift if @queue.size > 0 && !@timer.waiting
      @camera.update(@player.x, @player.y)
      input_calc if !@timer.waiting
      do_action if @action
      @player.update
    end
  end

  def show_menu(menu)
    @menu.show_menu(menu)
    @mode = :menu
  end

  def show_message(text)
    @menu.show_message(text.clone)
    @mode = :menu
  end

  def show_prompt(menu, text)
    @menu.show_prompt(menu, text.clone)
    @mode = :menu
  end

  def fx(key)
    @sounds.fx(key)
  end

  def draw
    case @mode
    when :title
      @title.draw
    when :menu
      @camera.draw(@viewport, @map.tile_array, @map.def_img)
      @player.draw(false)
      @menu.draw
    when :message
      @camera.draw(@viewport, @map.tile_array, @map.def_img)
      @player.draw(false)
      @menu.message.draw
    else # :field
      @camera.draw(@viewport, @map.tile_array, @map.def_img)
      @player.draw
    end
  end

  def generate_maps
    @maps = { 
      farm: [Map.new(self, @menu, :farm, FARM_MAP_ARRAY,1)],
      big: [Map.new(self, @menu, :big, BIG_MAP_ARRAY,0)],
      home: [Map.new(self, @menu, :home, HOME_MAP_ARRAY)]
    }
  end

  def effect(effect)
    @camera.effect(effect)
  end

  def set_timer(frames)
    @timer.set_timer(frames)
  end

  def calc_viewport
    @viewport = @map.show_tiles(@player.x,@player.y)
  end

  def change_map(change_map_hash)
    @queue << [:change_map, change_map_hash]
  end

  def do_action
    if @action[0] == :change_map
      change_map_hash = @action[1]
      @map = @maps[change_map_hash[:warp_map_id]][0]
      @player.map = @map
      @player.warp(change_map_hash[:warp_x], change_map_hash[:warp_y], change_map_hash[:direction])
      calc_viewport
      effect(:fade_in)
      @action = nil
    end
  end

  def calc_menu
    @exit_confirm_menu = [
      { print: "Yes", block: lambda { |params|
        params[:window].close_game
        } },
      { print: "No", block: lambda { |params|
        params[:menu].close
        } } ] 
    @window_menu = [
      { print: "Energy", block: lambda { |params| 
        params[:message].show_text("You have #{params[:player].energy} left today.")
        } },
      { print: "Date", block: lambda { |params|
        params[:message].show_text("Today is day #{params[:window].calendar.day}; there are #{30 - params[:window].calendar.day} days left until market. Get to work!")
        } },
      { print: "Inventory", block: lambda { |params|
        params[:message].show_text("This feature coming soon.")
        } },
      { print: "Exit Game", block: lambda { |params| #calls a submenu!
        params[:menu].use_sub_menu(:sub_menu1, @exit_confirm_menu)
        params[:message].show_text("Are you sure you want to quit?", true)
        } },
      { print: "Cancel", block: lambda { |params|
        params[:menu].close
        } } ]
  end

  def input_calc
    if @mode == :field
      if @player.vel_x == 0 && @player.vel_y == 0
        if (button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft) || button_down?(Gosu::KbA))
          @player.accelerate(:left)
        elsif (button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight) || button_down?(Gosu::KbD))
          @player.accelerate(:right)
        elsif (button_down?(Gosu::KbUp) || button_down?(Gosu::GpUp) || button_down?(Gosu::KbW))
          @player.accelerate(:up)
        elsif (button_down?(Gosu::KbDown) || button_down?(Gosu::GpDown) || button_down?(Gosu::KbS))
          @player.accelerate(:down)
        end
      end
    end
  end

  def button_down(id)
    if @player.vel_x == 0 && @player.vel_y == 0
      case id
      when Gosu::KbZ
        case @mode
        when :title
          @title.interact
        when :menu
          @menu.interact
        when :field
          @player.interact
        end
      when Gosu::KbX
        case @mode
        when :title
          @title.interact
        when :menu
          @menu.close
        when :field
          show_menu(@window_menu)
        end
      when Gosu::KbUp
        case @mode
        when :title then @title.move_up
        when :menu then @menu.move_up
        end
      when Gosu::KbDown
        case @mode
        when :title then @title.move_down
        when :menu then @menu.move_down
        end
      end
    end
  end

  def close_game
    close
  end
end
window = GameWindow.new
window.show
