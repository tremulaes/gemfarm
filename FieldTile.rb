class FieldTile
  def initialize(window)
    @window = window
    @animation = Gosu::Image::load_tiles(window, "media/sprites/field_tile.png", 16, 16, true)
    @state = { hoed: false, fertilized: false }
    calc_animation
    @angle = rand(4) * 90
    calc_menu
  end

  def hoed=(boolean)
    @state[:hoed] = boolean
    calc_animation
  end

  def fertilized=(boolean)
    @state[:fertilized] = boolean
    calc_animation
  end

  def touch
    @window.show_menu(@field_tile_menu)
  end

  def walk_on
  end

  def calc_menu
    @field_plant_menu = [
      { print: "Plant Corn", block: lambda { |params|
        if !params[:player].no_energy?(2)
          params[:player].facing_tile.new_crop(:corn, @img, @state, "SAPPHIRE CORN")
          params[:message].show_text("You planted SAPPHIRE CORN")
          params[:player].energy_change(-2)
        end
        } },
      { print: "Plant Pumpkin", block: lambda { |params|
        if !params[:player].no_energy?(2)
          params[:player].facing_tile.new_crop(:pumpkin, @img, @state, "EMERALD PUMPKIN")
          params[:message].show_text("You planted EMERALD PUMPKIN")
          params[:player].energy_change(-2)
        end
        } },
      { print: "Plant Tomato", block: lambda { |params|
        if !params[:player].no_energy?(2)
          params[:player].facing_tile.new_crop(:tomato, @img, @state, "AMETHYST TOMATO")
          params[:message].show_text("You planted AMETHYST TOMATO")
          params[:player].energy_change(-2)
        end
        } },
      { print: "Cancel", block: lambda { |params|
        params[:menu].close
        } } ]
    @field_tile_menu = [
      { print: "Hoe Soil", block: lambda { |params|
        if !params[:player].no_energy?(2)
          params[:message].show_text("You hoe the soil vigorously. Good work. Seriously.")
          params[:player].facing_tile.holding.hoed = true
          params[:player].energy_change(-2)
        end
      } },
      { print: "Fertilize", block: lambda { |params|
        if !params[:player].no_energy?(1)
          params[:message].show_text("Cow dung is cheap, and you spread it all around for good measure.")
          params[:player].facing_tile.holding.fertilized = true
          params[:player].energy_change(-1)
        end
      } },
      { print: "Plant", block: lambda { |params|
        params[:menu].use_sub_menu(:sub_menu1, @field_plant_menu)
        params[:message].show_text("What would you like to plant?", true)
      } },
      { print: "Cancel", block: lambda { |params|
        params[:menu].close
        } } ]
  end

  def calc_animation
    if @state[:hoed] && !@state[:fertilized]
      @img = @animation[1]
    elsif @state[:fertilized] && !@state[:hoed]
      @img = @animation[3]
    elsif @state[:hoed] && @state[:fertilized]
      @img = @animation[2]
    else 
      @img = @animation[0]
    end
  end

  def draw(x, y)
    if !@state[:hoed] && !@state[:fertilized]
      @img.draw_rot(x + 32, y + 32, 2, @angle, 0.5, 0.5, 4, 4)
    else
      @img.draw(x, y, 2, 4, 4)
    end
  end
end