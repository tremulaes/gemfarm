class EmeraldPumpkin < Crop
  def load_tileset
    @animation = Gosu::Image::load_tiles(@window, "media/sprites/emerald_pumpkin.png", 16, 16, true)
  end

  def calc_special
    @carved = false
    @daily_up[:massage] = 0
    @daily_up[:carve] = 0
    @carve_confirm_menu = [
      { print: "Practice Knifework", block: lambda { |params|
        if !params[:player].no_energy?(2)
          if @stage >= 2 && !@carved
            params[:message].show_text("Wow, it actually came out well. Good work.")
            @daily_up[:carve] += 1
            @carved = true
          else
            params[:player].facing_tile.erase_crop
            params[:message].show_text("The poor guy just couldn't hold up to the pressure.")
          end  
          params[:player].energy_change(-2)
        end
      } },
      { print: "Leave it alone", block: lambda { |params| 
        params[:message].show_text("The #{@name} watches you grimly from afar.")
      } } ]
    @crop_menu.insert(-3, { print: "Massage", block: lambda { |params|
      if !params[:player].no_energy?(3)
        @daily_up[:massage] += 1
        params[:message].show_text("You rubbed down the gentle green curves of the #{@name}.")
        params[:player].energy_change(-3)
      end
    } } )
    @crop_menu.insert(-3, { print: "Carve", block: lambda { |params| 
      params[:menu].use_sub_menu(:sub_menu1, @carve_confirm_menu)
      params[:message].show_text("Are you really sure about this?", true)
    } } )
  end

  def calc_happy #water, weed, spray, massage, carve
    @daily_up[:happy] = 0
    @daily_up[:water] > 8 ? @daily_up[:happy] += 20 : @daily_up[:happy] += @daily_up[:water] * 3
    @daily_up[:happy] += @daily_up[:weed] * 4
    @daily_up[:spray] > 5 ? @daily_up[:happy] += 30 : @daily_up[:happy] += @daily_up[:spray] * 6
    @daily_up[:massage] < 4 ? @daily_up[:happy] += @daily_up[:massage] * 6 : @daily_up[:happy] += @daily_up[:massage] * 4
    @daily_up[:happy] += @daily_up[:carve] * 40
    calc_animation
  end
end