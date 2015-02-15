# CROPS = [
# ]

class Crop
  def initialize(crop_hash)
    @map = crop_hash[:map]
    @x = @map.tile_at(crop_hash[:x], crop_hash[:y]).x
    @y = @map.tile_at(crop_hash[:x], crop_hash[:y]).y
    @type = crop_hash[:type]
    @window = crop_hash[:window]
    @stage = 0
    @bubble_sound = Gosu::Sample.new(@window, "media/bubble.wav")
    @animation = Gosu::Image::load_tiles(@window, "media/sprites/sapphire_corn.png", 16, 16, true)
    @anim0 = [@animation[0],@animation[1]]
    @anim1 = [@animation[2],@animation[3]]
    @anim2 = [@animation[4],@animation[5]]
    @anim3 = [@animation[6],@animation[7]]
    @map.tile_at(@x, @y).collidable = true
  end

  def touch
    @bubble_sound.play
    grow
  end

  def grow
    # if rand(800) < 5
      @stage >= 3 ? @stage = 0 : @stage += 1
    # end
  end

  def draw
    img = 
      case @stage
      when 0 then @anim0[Gosu::milliseconds / 600 % @anim0.size]
      when 1 then @anim1[Gosu::milliseconds / 600 % @anim1.size]
      when 2 then @anim2[Gosu::milliseconds / 600 % @anim2.size]
      when 3 then @anim3[Gosu::milliseconds / 600 % @anim3.size]
      end
    img.draw(@x, @y, 2, 4, 4)
  end
end