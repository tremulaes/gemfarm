class Crop
  attr_reader :type
  def initialize(crop_hash)
    @window = crop_hash[:window]
    @tile = crop_hash[:tile]
    calc_menu
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
    @window.show_menu(@crop_menu) 
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

  def calc_menu
    @crop_menu = [
      { print: "Water", block: lambda { 
        |params| params[:window].fx(:bubble); params[:player].facing_tile.holding.grow; params[:menu].close
        } },
      { print: "Dance", block: lambda {
        |params| params[:message].set_text("you danced with the crop but it's really hard to say why you would think that's a good idea.")
        } },
      { print: "Kick", block: lambda {
        |params| params[:player].facing_tile.kill_crop
        params[:message].set_text("You are a meanie you killed the crop"); params[:player].energy -= 1
        } },
      { print: "Cancel", block: lambda {
        |params| params[:menu].close
        } } ]
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