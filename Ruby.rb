require "gosu"



class Ruby

attr_accessor :move_up, :move_left, :move_right, :move_down, :position_x, :position_y

    def initialize(window)
        @window = window
        @move_left = false
        @move_right = false
        @move_up = false
        @move_down = false

        @position_x = 0
        @position_y = 0

        @walk_down_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_down_animation][:animation_arguments])
        @walk_left_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_left_animation][:animation_arguments])
        @walk_right_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_right_animation][:animation_arguments])
        @walk_up_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_up_animation][:animation_arguments])
    end

    def update

    if @ruby.move_down
     @walk_down_animation.update
    elsif @ruby.move_left
     @walk_left_animation.update
    elsif @ruby.move_right
      @walk_right_animation.update
    elsif @ruby.move_up
      @walk_up_animation.update
    end
    

    end

    def step(x, y)

        while position_y != position_y + y
        
        end

        move_up = false
        move_down = false
        move_right = false
        move_left = false

    end

    def draw
        if @ruby.move_down
         @walk_down_animation.draw(position_x, position_y)
        elsif @ruby.move_left
         @walk_left_animation.draw(position_x, position_y)
        elsif @ruby.move_right
          @walk_right_animation.draw(position_x, position_y)
        elsif @ruby.move_up
          @walk_up_animation.draw(position_x, position_y)
        end
    end
end