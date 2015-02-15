require 'gosu'
require_relative "sprite_data"
require_relative 'SpriteAnimation'
require_relative 'Ruby'
require_relative 'map'

class GameWindow < Gosu::Window
  def initialize
    super(960, 640, false)
    self.caption = 'Gem Farm'
    @ruby = Ruby.new(self)
    @map = Map.new(self, MAP_ARRAY)
    @ruby.warp(400,300)
  end

  def update
    # if button_down(Gosu::KbUp) || button_down(Gosu::GpUp) || button_down(Gosu::KbW)
    #   @ruby.accelerate(:up)
    # end

    # if button_down(Gosu::KbLeft) || button_down(Gosu::GpLeft) || button_down(Gosu::KbA)
    #   @ruby.accelerate(:left)
    # end

    # if button_down(Gosu::KbRight) || button_down(Gosu::GpRight) || button_down(Gosu::KbD)
    #   @ruby.accelerate(:right)
    # end

    # if button_down(Gosu::KbDown) || button_down(Gosu::GpDown) || button_down(Gosu::KbS)
    #   @ruby.accelerate(:down)
    # end

    @ruby.move
  end

  def draw
    @map.draw
    @ruby.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    elsif (id == Gosu::KbLeft) || (id == Gosu::GpLeft) || (id == Gosu::KbA)
      @ruby.accelerate(:left)
    elsif (id == Gosu::KbRight) || (id == Gosu::GpRight) || (id == Gosu::KbD)
      @ruby.accelerate(:right)
    elsif (id == Gosu::KbUp) || (id == Gosu::GpUp) || (id == Gosu::KbW)
      @ruby.accelerate(:up)
    elsif (id == Gosu::KbDown) || (id == Gosu::GpDown) || (id == Gosu::KbS)
      @ruby.accelerate(:down)
    end
  end
end
window = GameWindow.new
window.show
