require 'gosu'
require_relative "sprite_data"
require_relative 'SpriteAnimation'
require_relative 'Ruby'
require_relative 'map'

class GameWindow < Gosu::Window
  def initialize
    super(960, 640, false)
    @window = self
    self.caption = 'Gem Farm'
    @ruby = Ruby.new(@window)
    @map = Map.new(self, MAP_ARRAY)

    @walk_down_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_down_animation][:animation_arguments])
   	@walk_left_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_left_animation][:animation_arguments])
    @walk_right_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_right_animation][:animation_arguments])
    @walk_up_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_up_animation][:animation_arguments])
  end

  def update
    if button_down? Gosu::KbUp or button_down? Gosu::GpUp or button_down? Gosu::KbW
      @ruby.move_up = true
      # @ruby.step(0, 64)
    end

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft or button_down? Gosu::KbA
      @ruby.move_left = true
      # @ruby.step(-64, 0)
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight or button_down? Gosu::KbD
      @ruby.move_right = true
      # @ruby.step(64, 0)
    end

    if button_down? Gosu::KbDown or button_down? Gosu::GpDown or button_down? Gosu::KbS
      @ruby.move_down = true
      #@ruby.step(0, -64)
    end

    @ruby.update


  end

  def draw
    @map.draw
    @ruby.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end
window = GameWindow.new
window.show
