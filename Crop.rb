class Crop
  def initialize(crop_hash)
    @window = crop_hash[:window]
    @tile = crop_hash[:tile]
    @x = @tile.x
    @y = @tile.y
    @type = crop_hash[:type]
    @menu = crop_hash[:menu]
    @stage = 0
    @animation = Gosu::Image::load_tiles(@window, "media/sprites/sapphire_corn.png", 16, 16, true)
    calc_animation
    @tile.collidable = true
    @current_frame = @animation[0]
  end

  def touch
    @menu.items = CROP_MENU
  end

  def grow
    @stage >= 3 ? @stage = 0 : @stage += 1
    calc_animation
  end

  def die
    @tile.collidable = false
    @tile.holding = nil
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