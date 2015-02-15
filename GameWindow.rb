require 'gosu'
require_relative 'Ruby'
require_relative 'map'
require_relative 'crop'

class GameWindow < Gosu::Window
  def initialize
    super(960, 640, false)
    self.caption = 'Gem Farm'
    @map = Map.new(self, MAP_ARRAY)
    @ruby = Ruby.new(self,@map)
    @background_music = Gosu::Song.new(self, "media/sound/farming.wav")
    @background_music.play(true)
    @ruby.warp(400,300)
    @crops = @map.crop_array

    # @map.set_crop(64,64,'placeholder', @map, self)
    # @map.set_crop(64,128,'placeholder', @map, self)
    # @map.set_crop(64,192,'placeholder', @map, self)
    # @map.set_crop(64,256,'placeholder', @map, self)
    # @map.set_crop(64,320,'placeholder', @map, self)
    # @map.set_crop(64,384,'placeholder', @map, self)
    # @map.set_crop(64,448,'placeholder', @map, self)
    # @map.set_crop(64,512,'placeholder', @map, self)
    # @crops << Crop.new(832,64,'placeholder', self, @map)
    # @crops << Crop.new(832,128,'placeholder', self, @map)
    # @crops << Crop.new(832,192,'placeholder', self, @map)
    # @crops << Crop.new(832,256,'placeholder', self, @map)
    # @crops << Crop.new(832,320,'placeholder', self, @map)
    # @crops << Crop.new(832,384,'placeholder', self, @map)
    # @crops << Crop.new(832,448,'placeholder', self, @map)
    # @crops << Crop.new(832,512,'placeholder', self, @map)
  end

  def update
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
    @crops = @map.crop_array
    @ruby.move
  end

  def draw
    @map.draw
    @ruby.draw
    @crops.each {|crop| crop.draw }
  end

  def button_down(id)
    if @ruby.vel_x == 0 && @ruby.vel_y == 0
      if id == Gosu::KbEscape
        close
      elsif id == Gosu::KbZ
        @ruby.interact
      end
    end
  end
end
window = GameWindow.new
window.show
