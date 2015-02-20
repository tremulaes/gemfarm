module MenuAction
  
  def calc_menu
    @params.clear
    @params = {
      window: @window,
      menu: self,
      message: @message,
      player: @player
    }
  end
    # @menus = {
    #   field_tile_menu: [
    #     { print: "Hoe Soil", block: lambda {
    #       |params| params[0].set_text("You hoed the soil vigorously. Good work. Seriously.")
    #     }, params: [@message] },
    #     { print: "Plant", block: lambda {
    #       |params| params[0].use_sub_menu(:sub_menu1, :plant_menu)
    #       params[1].set_text("What would you like to plant?", true)
    #     }, params: [self, @message] },
    #     { print: "Cancel", block: lambda {
    #       |params| params[0].close
    #       }, params: [self] } ],
    #   crop_menu: [
    #     { print: "Water", block: lambda { 
    #       |params| params[0].fx(:bubble); params[1].grow; params[0].mode = :field 
    #       }, params: [@window, @player.facing_tile.holding] },
    #     { print: "Dance", block: lambda {
    #       |params| params[0].set_text("you danced with the crop but it's really hard to say why you would think that's a good idea.")
    #       }, params: [@message] },
    #     { print: "Kick", block: lambda {
    #       |params| params[1].kill_crop; params[0].set_text("You are a meanie you killed the crop")
    #       params[2].energy -= 1
    #       }, params: [@message, @player.facing_tile, @player] },
    #     { print: "Cancel", block: lambda {
    #       |params| params[0].close
    #       }, params: [self] } ],
    #   plant_menu: [
    #     { print: "Plant Corn", block: lambda {
    #       |params| params[1].new_crop(:corn)
    #       params[0].set_text("You planted SAPPHIRE CORN"); params[2].energy -= 1
    #       }, params: [@message, @player.facing_tile, @player] },
    #     { print: "Plant Pumpkin", block: lambda {
    #       |params| params[1].new_crop(:pumpkin)
    #       params[0].set_text("You planted EMERALD PUMPKIN"); params[2].energy -= 1
    #       }, params: [@message, @player.facing_tile, @player] },
    #     { print: "Plant Tomato", block: lambda {
    #       |params| params[1].new_crop(:tomato)
    #       params[0].set_text("You planted AMETHYST TOMATO"); params[2].energy -= 1
    #       }, params: [@message, @player.facing_tile, @player] },
    #     { print: "Cancel", block: lambda {
    #       |params| params[0].close
    #       }, params: [self] } ],
      # map_menu: [
      #   { print: "Energy", block: lambda {
      #     |params| params[0].set_text("You have #{params[1]} left today.")
      #     }, params: [@message, @player.energy] },
      #   { print: "Date", block: lambda {
      #     |params| params[1].set_text("Today is day #{params[0].calendar.day}; there are #{30 - params[0].calendar.day} days left until market. Get to work!")
      #     }, params: [@window, @message] },
      #   { print: "Day Pass", block: lambda {
      #     |params| params[0].calendar.day_pass
      #     }, params: [@window] },
      #   { print: "Exit Game", block: lambda { # calls for submenu!
      #     |params| params[0].use_sub_menu(:sub_menu1, :exit_confirm_menu)
      #     params[1].set_text("Are you sure you want to quit?", true)
      #     }, params: [self, @message] },
      #   { print: "Cancel", block: lambda {
      #     |params| params[0].close
      #     }, params: [self] } ],
    #   exit_confirm_menu: [ # nested; sub_menu1
    #     { print: "Yes", block: lambda {
    #       |params| params[0].close_game
    #       }, params: [@window] },
    #     { print: "No", block: lambda {
    #       |params| params[0].close
    #       }, params: [@menu] } ]  
    # }
  # end
end

# { print: "XX", block: lambda {
#       |params| params[INDEX].COMMAND
#       }, params: [a, b] }