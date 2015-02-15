require 'gosu'
require_relative "sprite_data"
require_relative 'SpriteAnimation'
require_relative 'Ruby'


class GameWindow < Gosu::Window
  def initialize
   super(960, 640, false)
   @window = self
   self.caption = 'Gem Farm'
   ruby = Ruby.new

   	@walk_down_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_down_animation][:animation_arguments])
   	@walk_left_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_left_animation][:animation_arguments])
    @walk_right_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_right_animation][:animation_arguments])
    @walk_up_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_up_animation][:animation_arguments])

  end

  def update
    if ruby.move_down
  	 @walk_down_animation.update
    elsif ruby.move_left
  	 @walk_left_animation.update
    elsif ruby.move_right
      @walk_right_animation.update
    elsif ruby.move_up
      @walk_up_animation.update
    end
  end

  def draw
  	@walk_down_animation.draw
  	@walk_left_animation.draw(16, 0)
    @walk_up_animation.draw(32, 0)
    @walk_right_animation.draw(48, 0)
  	# @ruby_image.draw(0,0,0)
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
