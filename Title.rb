class Title
  def initialize(window)
    @window = window
    @cursor = 0
    @white = 0xffffffff
    @black = 0xff000000
    @mode = :title # :title, :white_fade
    @animation = Gosu::Image::load_tiles(window, "media/sprites/ruby.png", 16, 16, true)
    calc_animation
    @corn = Gosu::Image::load_tiles(window, "media/sprites/sapphire_corn.png", 16, 16, true)
    @pumpkin = Gosu::Image::load_tiles(window, "media/sprites/emerald_pumpkin.png", 16, 16, true)
    @tomato = Gosu::Image::load_tiles(window, "media/sprites/amethyst_tomato.png", 16, 16, true)
    @font = Gosu::Font.new(@window, "Courier", 12)
    @menu_list = ["New Game", "Quit"]
    @rubys = Array.new
    @crops = Array.new
    @ruby_size = 2.0
    @ruby_x, @ruby_y = 352, 352
    calc_ruby_xy
    @x, @y, @h, @w, @b = 247, 500, 114, 210, 5
  end

  def interact
    if @cursor == 0
      fade_out
      @mode = :white_fade
    else 
      @window.close_game
    end
  end

  def move_up
    @cursor == 0 ? @cursor = 1 : @cursor -= 1
  end

  def move_down
    @cursor == 1 ? @cursor = 0 : @cursor += 1
  end

  def start_game
    @window.sounds.effect(:fade_out,:start_game)
    @window.effect(:white_fade)
    @window.mode = :field
  end

  def update
    case @mode
    when :white_fade
      if @delta <= @final_color
        @delta += 16777216 * 8 # 1/256 for alpha column!
      else
        start_game
      end
    else # :title
      calc_animation
      if rand(100) < 4 && @rubys.size < 250
        @rubys.push(TitleImage.new(@animation))
        if @ruby_size <= 20
          @ruby_size += 0.1
          calc_ruby_xy
        end
      end
      if rand(100) < 4 && @crops.size < 250
        @crops.push(TitleCrop.new([@corn, @tomato, @pumpkin].sample))
      end
      @rubys.each {|ruby| ruby.move }
      @crops.each {|crop| crop.grow }
    end
  end

  def calc_ruby_xy
    @ruby_x = @ruby_y = 352 - 8 * @ruby_size
  end

  def calc_animation
    @current_anim = 
    case Gosu::milliseconds / 2000 % 4
    when 0 then [@animation[8],@animation[9],@animation[10],@animation[11]]
    when 1 then [@animation[0],@animation[1],@animation[2],@animation[3]]
    when 2 then [@animation[12],@animation[13],@animation[14],@animation[15]]
    when 3 then [@animation[4],@animation[5],@animation[6],@animation[7]]
    end
  end

  def fade_out
    @final_color = 0xFFFFFFFF
    @delta = 0x00FFFFFF
    @window.set_timer(60)
  end

  def draw
    # white background
    @window.draw_quad(0, 0, @black, 704, 0, @black, 0, 704, @black, 704, 704, @black, 0)
    #text
    @font.draw("GemFarm", 282, 50, 2, 4.0, 4.0, @white)
    @font.draw("A Farming Adventure", 162, 100, 2, 4.0, 4.0, @white)
    # picture
    img = @current_anim[Gosu::milliseconds / 200 % 4]
    img.draw(@ruby_x, @ruby_x, 2, @ruby_size, @ruby_size)
    @rubys.each {|ruby| ruby.draw }
    @crops.each {|crop| crop.draw }
    # menu with two options (new game/quit)
    @window.draw_quad(@x - @b, @y - @b, @white, @x + @w + @b, @y - @b, @white, @x - @b, @y + @h + @b, @white, @x + @w + @b, @y + @h + @b, @white, 4) #black box
    @window.draw_quad(@x, @y, @black, @x + @w, @y, @black, @x, @y + @h, @black, @x + @w, @y + @h, @black, 5) # white box
    @menu_list.each_with_index do |text, index|
      @font.draw("#{text}", @x + 30 , @y + 10 + (index * 52), 6, 4.0, 4.0, @white)
    end
    @window.draw_triangle(@x + 5, @cursor * 52 + 20 + @y, @white, @x + 5, @cursor * 52 + 40 + @y, @white, @x + 22, @cursor * 52 + 30 + @y, @white, 7) # cursor
    case @mode
    # fade
    when :white_fade then @window.draw_quad(0, 0, @delta, 704, 0, @delta, 0, 704, @delta, 704, 704, @delta, 10)
    end
  end
end

class TitleCrop
  def initialize(animation)
    @animation = animation
    @current_anim = [@animation[0],@animation[1]] 
    @stage = 0
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @ratio = rand(11) / 10.00 + 3.5
    @speed = rand(500) + 150
    @x = rand * 704
    @y = rand * 704
  end

  def grow
    if rand(@speed / 5) < 2
      @stage == 3 ? @stage = 0 : @stage += 1
      @current_anim = 
        case @stage
        when 0 then [@animation[0],@animation[1]]
        when 1 then [@animation[2],@animation[3]]
        when 2 then [@animation[4],@animation[5]]
        when 3 then [@animation[6],@animation[7]]
        end
    end
  end

  def draw
    img = @current_anim[Gosu::milliseconds / @speed % 2]
    img.draw(@x, @y, 1, @ratio, @ratio, @color, :add)
  end
end

class TitleImage
  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @ratio = rand(11) / 10.00 + 3.5
    @speed = rand(500) + 150
    @x = rand * 704
    @y = rand * 704
    @direction = :down
    @down_anim = [@animation[0],@animation[1],@animation[2],@animation[3]]
    @left_anim = [@animation[4],@animation[5],@animation[6],@animation[7]]
    @up_anim = [@animation[8],@animation[9],@animation[10],@animation[11]]
    @right_anim = [@animation[12],@animation[13],@animation[14],@animation[15]]
  end

  def move
    if rand(@speed / 5) < 2 
      case rand(0..3)
      when 0 
        @x += 8 * @ratio
        @direction = :right
      when 1 
        @x -= 8 * @ratio
        @direction = :left
      when 2
        @y -= 8 * @ratio
        @direction = :up
      when 3
        @y += 8 * @ratio
        @direction = :down
      end
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
    img = cur_anim[Gosu::milliseconds / @speed % 4]
    img.draw(@x - img.width, @y - img.height, 1, @ratio, @ratio, @color, :add)
  end
end