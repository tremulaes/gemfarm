require "gosu"


class Ruby

attr_accessor :move_up, :move_left, :move_right, :move_down, :position_x, :position_y

    def initialize(window)
        @window = window
        @move_left = false
        @move_right = false
        @move_up = false
        @move_down = false

        @position_x = 300
        @position_y = 300

        @walk_down_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_down_animation][:animation_arguments])
        @walk_left_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_left_animation][:animation_arguments])
        @walk_right_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_right_animation][:animation_arguments])
        @walk_up_animation = SpriteAnimation.new(@window, *SPRITE_HASH[:walk_up_animation][:animation_arguments])
    end

    def update

        if @move_down
            # step(0, 64)
            @walk_down_animation.update
        elsif @move_left
            # step(-64, 0)
            @walk_left_animation.update
        elsif @move_right
            # step(64, 0)
            @walk_right_animation.update
        elsif @move_up
             step(0, -64)
            @walk_up_animation.update
        end
    

    end

    def step(x, y)

        if x < 0
            while @position_x > @position_x + x
                @position_x = @position_x - 1
            end
        elsif y < 0 #move up
            while @position_y >= position_y + y
                puts @position_y
                @position_y = @position_y - 1
            end
        elsif y > 0
            while @position_y < @position_y + y
                @position_y = @position_y + 1
            end
        elsif x > 0 
            while @position_x < @position_x + x
                @position_x = @position_x + 1
            end
        end

        @move_up = false
        @move_down = false
        @move_right = false
        @move_left = false
    end

    def draw
        if @move_down
         @walk_down_animation.draw(position_x, position_y, 1)
        elsif @move_left
         @walk_left_animation.draw(position_x, position_y, 1)
        elsif @move_right
          @walk_right_animation.draw(position_x, position_y, 1)
        elsif @move_up
          @walk_up_animation.draw(position_x, position_y, 1)
        end
    end
end