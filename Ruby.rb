require "gosu"

class Ruby
  def initialize(window)
    @window = window
    @animation = Gosu::Image::load_tiles(window, "media/sprites/RubyDraft_SM.png", 16, 16, true)
    @step_interval = 64
    @down_anim = [@animation[0],@animation[1],@animation[2],@animation[3]]
    @left_anim = [@animation[4],@animation[5],@animation[6],@animation[7]]
    @up_anim = [@animation[8],@animation[9],@animation[10],@animation[11]]
    @right_anim = [@animation[12],@animation[13],@animation[14],@animation[15]]
    @direction = :down
    @x = @y = @vel_x = @vel_y = 0
    @expected_x, @expected_y = 0, 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def accelerate(direction)
    if (@vel_x == 0) && (@vel_y == 0)
      @direction = direction
      case @direction
      when :up 
        @vel_y = -2.5
        @expected_y = (@y - @step_interval) % 640
      when :down
        @vel_y = 2.5
        @expected_y = (@y + @step_interval) % 640
      when :left 
        @vel_x = -2.5
        @expected_x = (@x - @step_interval) % 960
      when :right
        @vel_x = 2.5
        @expected_x = (@x + @step_interval) % 960
      end
    end
  end

  def move
    case @direction
    when :up 
      @y += @vel_y
      @vel_y = 0 if @y <= @expected_y
      @vel_x = 0
    when :down
      @y += @vel_y
      @vel_y = 0 if @y >= @expected_y
      @vel_x = 0
    when :left
      @x += @vel_x
      @vel_x = 0 if @x <= @expected_x
      @vel_y= 0
    when :right
      @x += @vel_x
      @vel_x = 0 if @x >= @expected_x
      @vel_y = 0
    end
    @x %= 960
    @y %= 640
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
    img.draw(@x - img.width, @y - img.height, 2, 4, 4)
  end
end