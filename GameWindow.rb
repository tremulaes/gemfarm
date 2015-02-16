require 'gosu'
require_relative 'Ruby'
require_relative 'Map'
require_relative 'MapGenerate'
require_relative 'Crop'
require_relative 'Menu'
require_relative 'Message'
require_relative 'InterfaceSound'
require_relative 'Camera'

class GameWindow < Gosu::Window
  attr_reader :map, :map_id, :ruby
  include InterfaceSound
  include MapGenerate

  def initialize
    super(704, 704, false)
    self.caption = 'Gem Farm'
    @message = Message.new(self)
    @menu = Menu.new(self, @message)
    generate_maps
    @map = @maps[:home][0]
    @map_id = :home
    @ruby = Ruby.new(self, @map)
    @background_music = Gosu::Song.new(self, "media/sound/farming.wav")
    @background_music.play(true)
    load_sounds
    @ruby.warp(400,300)
    @map.calc_show_tiles(@ruby.x,@ruby.y)
    @camera = Camera.new(self, @map)
  end

  def update
    input_calc
    @camera.update(@ruby.x, @ruby.y)
    @viewport = @map.show_tiles(@ruby.x,@ruby.y)
    @ruby.move
  end

  def draw
    # @map.draw
      @camera.draw(@viewport,@map.tile_array)
    if @menu.show != :false || @message.show == :true
      # @ruby.draw(false)
      @ruby.draw2(false)
      @menu.draw
      @message.draw
    else
      # @ruby.draw
      @ruby.draw2
    end
  end

  def change_map(map_id)
    @map = @maps[map_id][0]
    @map_id = map_id
    @ruby.map = @map
  end

  def input_calc
    if @menu.show == :false && @message.show == :false
      if @ruby.vel_x == 0 && @ruby.vel_y == 0
        if (button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft) || button_down?(Gosu::KbA))
          @ruby.accelerate(:left)
        elsif (button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight) || button_down?(Gosu::KbD))
          @ruby.accelerate(:right)
        elsif (button_down?(Gosu::KbUp) || button_down?(Gosu::GpUp) || button_down?(Gosu::KbW))
          @ruby.accelerate(:up)
        elsif (button_down?(Gosu::KbDown) || button_down?(Gosu::GpDown) || button_down?(Gosu::KbS))
          @ruby.accelerate(:down)
        end
      end
    end
  end

  def button_down(id)
    if @ruby.vel_x == 0 && @ruby.vel_y == 0
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
              @ruby.interact
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
