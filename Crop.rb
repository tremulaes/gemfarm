class Crop
  attr_reader :type
  def initialize(crop_hash)
    @window, @type, @name = crop_hash[:window], crop_hash[:type], crop_hash[:name]
    @field_image = crop_hash[:field_image]
    calc_field_multiplier(crop_hash[:field_state])
    load_tileset
    @daily_up = { happy: 0, water: 0, weed: 0, spray: 0 }
    @stage = 0
    @happy = 10
    calc_animation
    calc_menu
    calc_special
  end

  def load_tileset
    @animation = 
      case @type
      when :tomato then Gosu::Image::load_tiles(@window, "media/sprites/amethyst_tomato.png", 16, 16, true)
      when :corn then Gosu::Image::load_tiles(@window, "media/sprites/sapphire_corn.png", 16, 16, true)
      when :pumpkin then Gosu::Image::load_tiles(@window, "media/sprites/emerald_pumpkin.png", 16, 16, true)
      end
  end

  def calc_field_multiplier(field_state)
    @field_multiplier = 0.6
    @field_multiplier += 0.3 if field_state[:hoed]
    @field_multiplier += 0.2 if field_state[:fertilized]
  end

  def touch
    @window.show_menu(@crop_menu) 
    calc_happy
  end

  def day_pass
    calc_happy
    @happy += @daily_up[:happy]
    calc_grow
    @daily_up.each {|key, value| @daily_up[key] = 0 }
    calc_animation
  end

  def calc_happy
    puts "#{self}: #{@name} NOT SET TO CALC HAPPY"
  end

  def calc_grow
    case @stage
    when 0
      if @happy >= 100
        @stage = 1
        @happy = 100
      elsif @happy < 0
        @happy = 0
      end
    when 1
      if @happy >= 200
        @stage = 2
        @happy = 200
      elsif @happy < 100
        @stage = 1
        @happy = 50
      end
    when 2
      if @happy >= 300
        @stage = 3
        @happy = 300
        stage_3_harvest
      elsif @happy < 200
        @stage = 2
        @happy = 150
      end
    when 3
      if @happy < 300
        @stage = 2
        @happy = 250
        stage_3_harvest
      end
    end
  end

  def stage_3_harvest
    if @stage == 3
      @crop_menu[-2] = { print: "Harvest", block: lambda { |params| 
        if !params[:player].no_energy?(4)
          params[:player].facing_tile.erase_crop(:harvest)
          params[:message].show_text("You harvested the #{@name}. Good work.")
          params[:player].energy_change(-4)
        end
      } } 
    else
      @crop_menu[-2] = { print: "Kick", block: lambda { |params|
        if !params[:player].no_energy?(3)
          params[:player].facing_tile.erase_crop
          params[:message].show_text("The crop falls to pieces under your furious blows.")
          params[:player].energy_change(-3)
        end
      } }
    end
  end

  def calc_menu
    @crop_menu = [
      { print: "Water", block: lambda { |params| 
        params[:window].fx(:bubble)
        @daily_up[:water] += 1
        params[:menu].close
        } },
      { print: "Weed", block: lambda { |params|
        if !params[:player].no_energy?(2)
          @daily_up[:weed] += 1
          params[:message].show_text("You spend some time weeding the #{@type} and it looks much cleaner.")
          params[:player].energy_change(-2)
        end
        } },
      { print: "Spray", block: lambda { |params|
        if !params[:player].no_energy?(2)
          @daily_up[:spray] += 1
          params[:message].show_text("Spraying for pests could do the plant well.")
          params[:player].energy_change(-1)
        end
        } },
      { print: "Kick", block: lambda { |params|
        if !params[:player].no_energy?(3)
          params[:player].facing_tile.erase_crop
          params[:message].show_text("The crop falls to pieces under your furious blows.")
          params[:player].energy_change(-3)
        end
        } },
      { print: "Cancel", block: lambda { |params| 
        params[:menu].close
        } } ]
  end

  def calc_special
    @special_crop_menu =[
      { print: "Default", block: lambda { |params| 
        params[:message].show_text("If this is showing something is wrong!")
      } },
      { print: "Cancel", block: lambda { |params| 
        params[:menu].close
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
    if @happy + @daily_up[:happy] > ((@stage * 100) + 60) 
      @animation_speed = 300
    else 
      @animation_speed = 600
    end
  end

  def draw(x,y)
    img = @current_anim[Gosu::milliseconds / @animation_speed % 2]
    img.draw(x, y, 2, 4, 4)
    @field_image.draw(x, y, 1, 4, 4)
  end
end