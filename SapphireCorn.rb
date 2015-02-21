class SapphireCorn < Crop
  def load_tileset
    @animation = Gosu::Image::load_tiles(@window, "media/sprites/sapphire_corn.png", 16, 16, true)
  end

  def calc_special
    @daily_up[:hug] = 0
    @daily_up[:talk] = 0
    @hug_confirm_menu = [
      { print: "More Hugs!", block: lambda { |params| 
        if !params[:player].no_energy?(2)
          params[:player].facing_tile.erase_crop
          params[:message].show_text("Just a little too much love, it seems.")
          params[:player].energy_change(-2)
        end
      } },
      { print: "Give it some space", block: lambda { |params| 
        params[:message].show_text("The #{@name} looks almost relieved...")
      } } ]
    @crop_menu.insert(-3, { print: "Hug", block: lambda { |params|
      if @daily_up[:hug] > 2
        params[:menu].use_sub_menu(:sub_menu1, @hug_confirm_menu)
        params[:message].show_text("Are you sure? The #{@name} looks a little hugged out.", true)
      else
        if !params[:player].no_energy?(2)
          @daily_up[:hug] += 1
          params[:message].show_text("You gave the #{@name} a long, friendly hug.")
          params[:player].energy_change(-2)
        end
      end
    } } )
    @crop_menu.insert(-3, { print: "Converse", block: lambda { |params| 
      if !params[:player].no_energy?(1)
        @daily_up[:talk] += 1
        params[:message].show_text("You practically chat the corn's ears off.")
        params[:player].energy_change(-1)
      end
    } } )
  end

  def calc_happy #water, weed, spray, hug, talk
    @daily_up[:happy] = 0
    @daily_up[:water] > 5 ? @daily_up[:happy] += 20 : @daily_up[:happy] += @daily_up[:water] * 5
    @daily_up[:happy] += @daily_up[:weed] * 8
    @daily_up[:spray] > 1 ? @daily_up[:happy] += 3 : @daily_up[:happy] += @daily_up[:spray] * 5
    @daily_up[:happy] += @daily_up[:hug] * 6
    @daily_up[:talk] < 2 ? @daily_up[:happy] += @daily_up[:talk] * 3 : @daily_up[:happy] += @daily_up[:talk] * 5
    # puts "#{@daily_up}"
    calc_animation
  end
end