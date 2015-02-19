# @maps is a hash; key = map name, value is an array with relevant data
# array[0] = map object with initialize conditions
# array[1] = default warp coordinates [x,y] format
# array[2] = default image for outside tiles; default to nil if black is desired
# array[3] = hash array for default object instantiation [{type: [x,y]}, {type: [x,y]}]

require 'gosu'
require_relative 'Camera'
require_relative 'Crop'
require_relative 'InterfaceSound'
require_relative 'Map'
require_relative 'Message'
require_relative 'Menu'
require_relative 'Player'
require_relative 'Warp'

class GameWindow < Gosu::Window
  attr_reader :map, :map_id, :player, :waiting
  include InterfaceSound

  def initialize
    super(704, 704, false)
    self.caption = 'Gem Farm'
    @message = Message.new(self)
    @menu = Menu.new(self, @message)
    generate_maps
    @map = @maps[:big][0]
    @map_id = :big
    @player = Player.new(self, @map)
    @background_music = Gosu::Song.new(self, "media/sound/farming.wav")
    @background_music.play(true)
    load_sounds
    @player.warp(14,3)
    @map.calc_show_tiles(@player.x,@player.y)
    @camera = Camera.new(self, @map)
    @timer = 0
    @waiting = false
  end

  def update
    time_tick
    calc_viewport
    @camera.update(@player.x, @player.y)
    @menu.update
    input_calc
    @player.update
  end

  def draw
    @camera.draw(@viewport, @map.tile_array, @map.def_img)
    if @menu.show != :false || @message.show == :true
      @player.draw(false)
      @menu.draw
      @message.draw
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
    @timer = frames
    time_tick
  end

  def time_tick
    if @timer > 0
      @waiting = true
      @timer -= 1  
    else
      @waiting = false
    end
  end

  def calc_viewport
    @viewport = @map.show_tiles(@player.x,@player.y)
  end

  def change_map(change_map_hash)
    @map = @maps[change_map_hash[:warp_map_id]][0]
    @map_id = change_map_hash[:warp_map_id]
    @player.map = @map
    @player.warp(change_map_hash[:warp_x], change_map_hash[:warp_y])
    @player.direction = change_map_hash[:direction]
    calc_viewport
  end

  def input_calc
    if @menu.show == :false && @message.show == :false
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
        if @menu.show == :continue
          @menu.interact
        else
          if @message.show == :true
            @message.interact
          else
            if @menu.show == :true
              @menu.interact
            else
              @player.interact
            end
          end
        end
      when Gosu::KbX
        if @message.show == :false
          if @menu.show == :true
            fx(:close_menu)
            @menu.show = :false
          else
            fx(:open_menu)
            @menu.items = MAP_SCREEN_MENU
          end
        end
      when Gosu::KbUp
        if @menu.show != :false
          @menu.move_up
        end
      when Gosu::KbDown
        if @menu.show != :false
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
