class AmethystTomato < Crop
  def load_tileset
    @animation = Gosu::Image::load_tiles(@window, "media/sprites/amethyst_tomato.png", 16, 16, true)
  end

  def calc_special
    @carved = false
    @daily_up[:throw] = 0
    @daily_up[:laugh] = 0
    @throw_confirm_menu = [
      { print: "The Chicken", block: lambda { |params|
          params[:message].show_text("There are no chickens. You're alone. You ate the tomato.")
          params[:player].energy_change(+5)
          @daily_up[:throw] += 1
      } },
      { print: "The House", block: lambda { |params|
        if !params[:player].no_energy?(2)
          params[:message].show_text("You're really not that good of a shot. Bye tomato.")
          params[:player].energy_change(-2)
          @daily_up[:throw] += 1
        end
      } },
      { print: "Just Chuck It", block: lambda { |params|
          params[:message].show_text("You threw it in a random direction as hard as you could.")
          @daily_up[:throw] += 1
      } },
      { print: "Change your Mind", block: lambda { |params| 
        params[:message].show_text("Maybe you're not crazy.")
      } } ]
    @crop_menu.insert(-3, { print: "Throw", block: lambda { |params|
      if @stage == 0
        params[:message].show_text("Plan on throwing the stem? Let it grow.")
      else
        if @daily_up[:throw] == 0
          params[:menu].use_sub_menu(:sub_menu1, @throw_confirm_menu)
          params[:message].show_text("Who would you like to throw at?", true)
        else
          params[:message].show_text("This #{@name} has been through enough today.")
        end
      end
    } } )
    @crop_menu.insert(-3, { print: "Laugh", block: lambda { |params|
      if !params[:player].no_energy?(2)
        @daily_up[:laugh] += 1
        params[:message].show_text("The #{@name} is known for its good sense of humor.")
        params[:player].energy_change(-2)
      end
    } } )
  end

  def calc_happy #water, weed, spray, throw, laugh
    @daily_up[:happy] = 0
    @daily_up[:water] > 8 ? @daily_up[:happy] += 20 : @daily_up[:happy] += @daily_up[:water] * 3
    @daily_up[:happy] += @daily_up[:weed] * 8
    @daily_up[:spray] > 1 ? @daily_up[:happy] += 3 : @daily_up[:happy] += 5
    @daily_up[:happy] += @daily_up[:throw] * -10
    @daily_up[:happy] += @daily_up[:laugh] * 40
    calc_animation
  end
end