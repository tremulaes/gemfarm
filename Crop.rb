class Crop
  attr_reader :type
  def initialize(crop_hash)
    @window = crop_hash[:window]
    @tile = crop_hash[:tile]
    @x = @tile.x
    @y = @tile.y
    @type = crop_hash[:type]
    @menu = crop_hash[:menu]
    load_tileset
    @stage = 0
    calc_animation
    @tile.collidable = true
    @current_frame = @animation[0]
  end

  def load_tileset
    @animation = 
      case @type
      when :tomato then Gosu::Image::load_tiles(@window, "media/sprites/amethyst_tomato.png", 16, 16, true)
      when :corn then Gosu::Image::load_tiles(@window, "media/sprites/sapphire_corn.png", 16, 16, true)
      when :pumpkin then Gosu::Image::load_tiles(@window, "media/sprites/emerald_pumpkin.png", 16, 16, true)
      end
  end

  def touch
    @window.show_menu(:crop_menu) 
  end

  def walk_on
  end

  def day_pass
    puts "A day passed for me! I'm a #{@type} at stage #{@stage}!"
  end

  def grow
    @stage >= 3 ? @stage = 0 : @stage += 1
    calc_animation
  end

  def calc_animation
    @current_anim =
      case @stage
      when 0 then [@animation[0],@animation[1]]
      when 1 then [@animation[2],@animation[3]]
      when 2 then [@animation[4],@animation[5]]
      when 3 then [@animation[6],@animation[7]]
      end 
  end

  def draw(x,y, move = true)
    if move
      img = @current_anim[Gosu::milliseconds / 600 % 2]
      @current_frame = img
    else
      img = @current_frame
    end
    img.draw(x, y, 2, 4, 4)
  end
end