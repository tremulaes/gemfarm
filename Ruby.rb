require "gosu"

class Ruby
  attr_reader :direction, :vel_x, :vel_y

  def initialize(window, map)
    @window = window
    @map = map
    @animation = Gosu::Image::load_tiles(window, "media/sprites/ruby.png", 16, 16, true)
    @down_anim = [@animation[0],@animation[1],@animation[2],@animation[3]]
    @left_anim = [@animation[4],@animation[5],@animation[6],@animation[7]]
    @up_anim = [@animation[8],@animation[9],@animation[10],@animation[11]]
    @right_anim = [@animation[12],@animation[13],@animation[14],@animation[15]]
    @direction = :down
    @x = @y = @vel_x = @vel_y = 0
    @current_tile = @map.tile_at(@x, @y)
    @expected_tile = @current_tile
    @facing_tile
  end

  def warp(x, y)
    @x, @y = @map.tile_at(x, y).x, @map.tile_at(x, y).y
    @current_tile = @map.tile_at(@x, @y)
    @expected_tile = @current_tile
  end

  def interact
    @map.tile_at(@facing_tile.x, @facing_tile.y).touch
  end

  def accelerate(direction)
    @direction = direction
    case direction
    when :up
      @expected_tile = @map.tile_at(@current_tile.x, @current_tile.y - 64)
      @vel_y = -2.5 if !@expected_tile.collidable?
    when :down
      @expected_tile = @map.tile_at(@current_tile.x, @current_tile.y + 64)
      @vel_y = 2.5 if !@expected_tile.collidable?
    when :left
      @expected_tile = @map.tile_at(@current_tile.x - 64, @current_tile.y)
      @vel_x = -2.5 if !@expected_tile.collidable?
    when :right
      @expected_tile = @map.tile_at(@current_tile.x + 64, @current_tile.y)
      @vel_x = 2.5 if !@expected_tile.collidable?
    end
  end

  def move
    case @direction
    when :up
      @y += @vel_y
      if @y <= @expected_tile.y
        @vel_y = 0
        @current_tile = @map.tile_at(@expected_tile.x, @expected_tile.y)
      end
        @facing_tile = @map.tile_at(@current_tile.x, @current_tile.y - 64)
      @vel_x = 0
    when :down
      @y += @vel_y
      if @y >= @expected_tile.y
        @vel_y = 0
        @current_tile = @map.tile_at(@expected_tile.x, @expected_tile.y)
      end
        @facing_tile = @map.tile_at(@current_tile.x, @current_tile.y + 64)
      @vel_x = 0
    when :left
      @x += @vel_x
      if @x <= @expected_tile.x
        @vel_x = 0
        @current_tile = @map.tile_at(@expected_tile.x, @expected_tile.y)
      end
        @facing_tile = @map.tile_at(@current_tile.x - 64, @current_tile.y)
      @vel_y= 0
    when :right
      @x += @vel_x
      if @x >= @expected_tile.x
        @vel_x = 0
        @current_tile = @map.tile_at(@expected_tile.x, @expected_tile.y)
      end
        @facing_tile = @map.tile_at(@current_tile.x + 64, @current_tile.y)
      @vel_y = 0
    end
  end

  def draw
    cur_anim = 
    case @direction
    when :right then @right_anim
    when :left then @left_anim
    when :up then @up_anim
    when :down then @down_anim
    end
    img = cur_anim[Gosu::milliseconds / 200 % cur_anim.size]
    img.draw(@x, @y, 2, 4, 4)
  end
end