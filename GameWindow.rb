# @maps is a hash; key = map name, value is an array with relevant data
# array[0] = map object with initialize conditions
# array[1] = default warp coordinates [x,y] format
# array[2] = default image for outside tiles; default to nil if black is desired
# array[3] = hash array for default object instantiation [{type: [x,y]}, {type: [x,y]}]

require 'gosu'
require_relative 'Bed'
require_relative 'Calendar'
require_relative 'Camera'
require_relative 'Crop'
require_relative 'InterfaceSound'
require_relative 'Map'
require_relative 'Menu'
require_relative 'Player'
require_relative 'Warp'
require_relative 'TextEvent'

class GameWindow < Gosu::Window
  attr_reader :map, :map_id, :player, :waiting, :calendar
  attr_accessor :mode, :menu
  include InterfaceSound

  def initialize
    super(704, 704, false)
    self.caption = 'Gem Farm'
    generate_maps
    @map = @maps[:home][0]
    @map_id = :home
    @background_music = Gosu::Song.new(self, "media/sound/farming.wav")
    @background_music.play(true)
    load_sounds
    @player = Player.new(self, @map)
    @player.warp(4,5,:down)
    @map.calc_show_tiles(@player.x,@player.y)
    @calendar = Calendar.new(self)
    calc_menu
    @menu = Menu.new(self, @player, @window_menu)
    @camera = Camera.new(self, @map)
    @timer = 0
    @waiting = false
    @queue = []
    @action
    @mode = :field # :field, :message, :menu
  end

  def update
    time_tick
    calc_viewport
    @camera.update(@player.x, @player.y)
    input_calc if !@waiting
    do_action if @action
    @player.update
  end

  def show_menu(menu)
    puts "inside show menu"
    puts "#{menu}"
    @menu.current_list = menu
    @mode = :menu
  end

  def show_message(text)
    @menu.show_message(text.clone)
    @mode = :menu
  end

  def draw
    @camera.draw(@viewport, @map.tile_array, @map.def_img)
    case @mode
    when :menu
      @player.draw(false)
      @menu.draw
    when :message
      @player.draw(false)
      @menu.message.draw
    else
      @player.draw
    end
  end

  def generate_maps
    @maps = { 
      farm: [Map.new(self, @menu, :farm, FARM_MAP_ARRAY,1), [8,3]],
      big: [Map.new(self, @menu, :big, BIG_MAP_ARRAY,0), [4,5]],
      home: [Map.new(self, @menu, :home, HOME_MAP_ARRAY), [2,6]]
    }
  end

  def effect(effect)
    @camera.effect(effect)
  end

  def set_timer(frames)
    @timer = frames if frames > @timer
    time_tick
  end

  def time_tick
    if @timer > 0
      @waiting = true
      @timer -= 1  
    else
      @waiting = false
      @action = @queue.shift if @queue.size > 0
    end
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
      @map_id = change_map_hash[:warp_map_id]
      @player.map = @map
      @player.warp(change_map_hash[:warp_x], change_map_hash[:warp_y], change_map_hash[:direction])
      calc_viewport
      effect(:fade_in)
      @action = nil
    end
  end

  def calc_menu
    @exit_confirm_menu = [
      { print: "Yes", block: lambda {
        |params| params[:window].close_game
        } },
      { print: "No", block: lambda {
        |params| params[:menu].close
        } } ] 
    @window_menu = [
      { print: "Energy", block: lambda {
        |params| params[:message].set_text("You have #{params[:player].energy} left today.")
        } },
      { print: "Date", block: lambda {
        |params| params[:message].set_text("Today is day #{params[:window].calendar.day}; there are #{30 - params[:window].calendar.day} days left until market. Get to work!")
        } },
      { print: "Day Pass", block: lambda {
        |params| params[:window].calendar.day_pass
        } },
      { print: "Exit Game", block: lambda { # calls for submenu!
        |params| params[:menu].use_sub_menu(:sub_menu1, @exit_confirm_menu)
        params[:message].set_text("Are you sure you want to quit?", true)
        } },
      { print: "Cancel", block: lambda {
        |params| params[:menu].close
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
      when Gosu::KbEscape
        close_game
      when Gosu::KbZ
        case @mode
        when :menu
          @menu.interact
        when :field
          @player.interact
        end
      when Gosu::KbX
        case @mode
        when :menu
          @menu.close
        when :field
          show_menu(@window_menu)
        end
      when Gosu::KbUp
        if @mode == :menu
          @menu.move_up
        end
      when Gosu::KbDown
        if @mode == :menu
          @menu.move_down
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
