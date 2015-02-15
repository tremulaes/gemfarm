require "gosu"



class Ruby

attr_reader :move_up, :move_left, :move_right, :move_down

	def initialize
		@move_left = false
		@move_right = false
		@move_up = false
		@move_down = false


	end

	def update
		if button_down? Gosu::KbUp or button_down? Gosu::GpUp or button_down? Gosu::KbW
      @move_up = true
    else
    	@move_up = false
    end

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft or button_down? Gosu::KbA
      @move_left = true
    else
    	@move_left = false
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight or button_down? Gosu::KbD
      @move_right = true
    else
    	@move_right = false
    end

    if button_down? Gosu::KbDown or button_down? Gosu::GpDown or button_down? Gosu::KbS
      @move_down = true
    else
    	@move_down = false
    end

    if move_up
	end

	def draw

	end
end