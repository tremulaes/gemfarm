require "gosu"

class Player
  attr_reader :vel_x, :vel_y, :facing_tile, :x, :y #:direction, 
  attr_accessor :energy, :map
  
  def initialize(window, map)
    @window = window
    @map = map
    @energy = 5
    @animation = Gosu::Image::load_tiles(window, "media/sprites/ruby.png", 16, 16, true)
    @direction = :down
    calc_animation
    @x = @y = @vel_x = @vel_y = 0
    @current_tile = @map.tile_at(@x, @y)
    @expected_tile = @current_tile
    @facing_tile
    @current_frame = @animation[0]
  end

  def warp(x, y)
    @x, @y = x * 64, y * 64
    @current_tile = @map.tile_at(@x, @y)
    @expected_tile = @current_tile
  end

  def interact
    @facing_tile.touch
  end

  def set_facing
    @facing_tile =
    case @direction
    when :up then @facing_tile = @map.tile_at(@x, @y - 64)
    when :down then @facing_tile = @map.tile_at(@x, @y + 64)
    when :left then @facing_tile = @map.tile_at(@x - 64, @y)
    when :right then @facing_tile = @map.tile_at(@x + 64, @y)
    end
  end

  def accelerate(direction)
    @window.set_timer(5) if direction != @direction
    @direction = direction
    calc_animation
    set_facing
    if !@window.waiting
      case @direction
      when :up
        @expected_tile = @map.tile_at(@x, @y - 64)
        if @expected_tile.collidable?
          @window.fx(:collision)
        else
          @vel_y = -4
        end
      when :down
        @expected_tile = @map.tile_at(@x, @y + 64)
        if @expected_tile.collidable?
          @window.fx(:collision)
        else
          @vel_y = 4
        end
      when :left
        @expected_tile = @map.tile_at(@x - 64, @y)
        if @expected_tile.collidable?
          @window.fx(:collision)
        else
          @vel_x = -4
        end
      when :right
        @expected_tile = @map.tile_at(@x + 64, @y)
        if @expected_tile.collidable?
          @window.fx(:collision)
        else
          @vel_x = 4
        end
      end
    end
  end

  def move
    if !@window.waiting
      case @direction
      when :up
        @y += @vel_y
        if @y <= @expected_tile.y
          @vel_y = 0
          @current_tile = @map.tile_at(@x, @y)
        end
      when :down
        @y += @vel_y
        if @y >= @expected_tile.y
          @vel_y = 0
          @current_tile = @map.tile_at(@x, @y)
        end
      when :left
        @x += @vel_x
        if @x <= @expected_tile.x
          @vel_x = 0
          @current_tile = @map.tile_at(@x, @y)
        end
      when :right
        @x += @vel_x
        if @x >= @expected_tile.x
          @vel_x = 0
          @current_tile = @map.tile_at(@x, @y)
        end
      end
      set_facing
    end
  end

  def calc_animation
    @current_anim = 
    case @direction
    when :up then [@animation[8],@animation[9],@animation[10],@animation[11]]
    when :down then [@animation[0],@animation[1],@animation[2],@animation[3]]
    when :right then [@animation[12],@animation[13],@animation[14],@animation[15]]
    when :left then [@animation[4],@animation[5],@animation[6],@animation[7]]
    end
  end

  def draw(move = true)
    if move
      img = @current_anim[Gosu::milliseconds / 200 % 4]
      @current_frame = img
    else
      img = @current_frame
    end
    img.draw(320, 320, 2, 4, 4)
  end
end