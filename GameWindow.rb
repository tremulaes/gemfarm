require 'gosu'
require_relative 'Ruby'
require_relative 'Map'
require_relative 'Crop'
require_relative 'Menu'
require_relative 'Message'

class GameWindow < Gosu::Window
  attr_reader :map, :ruby
  def initialize
    super(960, 640, false)
    self.caption = 'Gem Farm'
    @message = Message.new(self)
    @menu = Menu.new(self, @message)
    @map = Map.new(self, @menu, MAP_ARRAY)
    @ruby = Ruby.new(self, @map)
    @background_music = Gosu::Song.new(self, "media/sound/farming.wav")
    @background_music.play(true)
    @background_music.volume = 0.25
    @ruby.warp(400,300)
    @crops = @map.crop_array
  end

  def update
    input_calc
    @crops = @map.crop_array
    @ruby.move
  end

  def input_calc
    if @menu.show == :false && @message.show == :false
      if @ruby.vel_x == 0 && @ruby.vel_y == 0
        if (button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft) || button_down?( Gosu::KbA))
          @ruby.accelerate(:left)
        elsif (button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight) || button_down?( Gosu::KbD))
          @ruby.accelerate(:right)
        elsif (button_down?(Gosu::KbUp) || button_down?(Gosu::GpUp) || button_down?( Gosu::KbW))
          @ruby.accelerate(:up)
        elsif (button_down?(Gosu::KbDown) || button_down?(Gosu::GpDown) || button_down?( Gosu::KbS))
          @ruby.accelerate(:down)
        end
      end
    end
  end

  def draw
    @map.draw
    if @menu.show != :false || @message.show == :true
      @ruby.draw(false)
      @crops.each {|crop| crop.draw(false) }
      @menu.draw
      @message.draw
    else
      @ruby.draw
      @crops.each {|crop| crop.draw }
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
            @menu.show = :false
          else
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
