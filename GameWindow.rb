require 'gosu'
require_relative "sprite_data"
require_relative 'SpriteAnimation'
require_relative 'Ruby'


class GameWindow < Gosu::Window
  def initialize
   super(960, 640, false)
   @window = self
   self.caption = 'Gem Farm'
   @ruby = Ruby.new(@window)

   	@walk_down_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_down_animation][:animation_arguments])
   	@walk_left_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_left_animation][:animation_arguments])
    @walk_right_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_right_animation][:animation_arguments])
    @walk_up_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_up_animation][:animation_arguments])

  end

  def update
    if button_down? Gosu::KbUp or button_down? Gosu::GpUp or button_down? Gosu::KbW
      ruby.move_up = true
      ruby.step(0, 64)
    end

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft or button_down? Gosu::KbA
      ruby.move_left = true
      ruby.step(-64, 0)
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight or button_down? Gosu::KbD
      ruby.move_right = true
      ruby.step(64, 0)
    end

    if button_down? Gosu::KbDown or button_down? Gosu::GpDown or button_down? Gosu::KbS
      ruby.move_down = true
      ruby.step(0, -64)
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpUp or button_down? Gosu::KbW
      ruby.ruby.move_down = true
    end

  end

  def draw



  	# @walk_down_animation.draw
  	# @walk_left_animation.draw(16, 0)
   #  @walk_up_animation.draw(32, 0)
   #  @walk_right_animation.draw(48, 0)
  	# # @ruby_image.draw(0,0,0)
  end


end

# class SpriteAnimation

# 	def initialize(img, start_index = 0, last_index = img.width/img.height, seconds_per_frame = 0.25)
# 		@img_array = img.load_tiles(GameWindow::GameWindow, img, start_index, last_index)
# 		@tile_count = 0
# 		@start_time
# 		@seconds_per_frame = seconds_per_frame
# 		@last_update_time = Time.now
# 	end

# 	def play_animation

# 	end

# 	def freeze_animation
# 	end

# 	def update
# 		if (Time.now - @last_update_time) > Aseconds_per_frame
# 			@last_update_time = Time.now
# 			if @tile_count >= @img_array.size
# 				@tile_count = 0
# 			else
# 				@tile_count += 1
# 			end
# 		end
# 	end

# 	def draw
# 		@img_array[tile_count].draw(0, 0, 0)

# 	end
# end

window = GameWindow.new
window.show
