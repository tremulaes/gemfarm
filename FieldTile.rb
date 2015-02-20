class FieldTile
  def initialize(window)
    @window = window
    calc_menu
  end

  def touch
    @window.show_menu(@field_tile_menu)
  end

  def walk_on
  end

  def calc_menu
    @field_plant_menu = [
      { print: "Plant Corn", block: lambda { |params|
        if !params[:player].no_energy?
          params[:player].facing_tile.new_crop(:corn)
          params[:message].show_text("You planted SAPPHIRE CORN")
          params[:player].energy_change(-1)
        end
        } },
      { print: "Plant Pumpkin", block: lambda { |params|
        if !params[:player].no_energy?
          params[:player].facing_tile.new_crop(:pumpkin)
          params[:message].show_text("You planted EMERALD PUMPKIN")
          params[:player].energy_change(-1)
        end
        } },
      { print: "Plant Tomato", block: lambda { |params|
        if !params[:player].no_energy?
          params[:player].facing_tile.new_crop(:tomato)
          params[:message].show_text("You planted AMETHYST TOMATO")
          params[:player].energy_change(-1)
        end
        } },
      { print: "Cancel", block: lambda {
        |params| params[:menu].close
        } } ]
    @field_tile_menu = [
      { print: "Hoe Soil", block: lambda {
        |params| params[:message].show_text("You hoe the soil vigorously. Good work. Seriously.")
      } },
      { print: "Plant", block: lambda {
        |params| params[:menu].use_sub_menu(:sub_menu1, @field_plant_menu)
        params[:message].show_text("What would you like to plant?", true)
      } },
      { print: "Cancel", block: lambda {
        |params| params[:menu].close
        } } ]
  end

  def draw(x, y)
  end
end