require 'gosu'
# require_relative 'GameWindow'

class SpriteAnimation
	def initialize(window, img_source, start_index, number_of_frames, seconds_per_frame = 0.25)
		@img_array = Gosu::Image::load_tiles(window, img_source, 16, 16, true)
		@frames_array = @img_array.slice(start_index, number_of_frames)
		# puts img.class
		@tile_count = 0
		@seconds_per_frame = seconds_per_frame
		@last_update_time = Time.now
	end

	def play_animation

	end

	def freeze_animation
	end

	def update
		if (Time.now - @last_update_time) > @seconds_per_frame
			@last_update_time = Time.now
			if @tile_count >= @frames_array.size - 1
				@tile_count = 0
			else
				@tile_count += 1
			end
		end
	end

	def draw(x = 0, y = 0)
		@frames_array[@tile_count].draw(x, y, 0)

	end
end
