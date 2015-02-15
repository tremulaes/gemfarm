class Crop
  def initialize(crop_hash)
    @map = crop_hash[:map]
    @x = @map.tile_at(crop_hash[:x], crop_hash[:y]).x
    @y = @map.tile_at(crop_hash[:x], crop_hash[:y]).y
    @type = crop_hash[:type]
    @window = crop_hash[:window]
    @menu = crop_hash[:menu]
    @stage = 0
    @bubble_sound = Gosu::Sample.new(@window, "media/bubble.wav")
    @animation = Gosu::Image::load_tiles(@window, "media/sprites/sapphire_corn.png", 16, 16, true)
    @anim0 = [@animation[0],@animation[1]]
    @anim1 = [@animation[2],@animation[3]]
    @anim2 = [@animation[4],@animation[5]]
    @anim3 = [@animation[6],@animation[7]]
    @map.tile_at(@x, @y).collidable = true
    @cur_frame = @anim0[0]
  end

  def touch
    @menu.items = CROP_MENU
  end

  def grow
    @bubble_sound.play
    @stage >= 3 ? @stage = 0 : @stage += 1
  end

  def laugh
  end

  def draw(move = true)
    cur_anim =
      case @stage
      when 0 then @anim0
      when 1 then @anim1
      when 2 then @anim2
      when 3 then @anim3
      end 
    if move
      img = cur_anim[Gosu::milliseconds / 600 % @anim0.size]
      @cur_frame = img
    else
      img = @cur_frame
    end
      img.draw(@x, @y, 2, 4, 4)
  end
end