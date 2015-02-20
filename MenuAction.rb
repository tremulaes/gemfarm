module MenuAction
  
  def calc_menu
    @menus = {
      crop_menu: [
        { print: "Water", block: lambda { 
          |params| params[0].fx(:bubble); params[1].grow; params[0].mode = :field 
          }, params: [@window, @player.facing_tile.holding] },
        { print: "Dance", block: lambda {
          |params| params[0].text = "you danced with the crop but it's really hard to say why you would think that's a good idea."
          }, params: [@message] },
        { print: "Kick", block: lambda {
          |params| params[1].die; params[0].text = "You are a meanie you killed the crop"
          }, params: [@message, @player.facing_tile.holding] },
        { print: "Cancel", block: lambda {
          |params| params[0].mode = :field
          }, params: [@window] } ],
      field_menu: [
        { print: "Plant Corn", block: lambda {
          |params| params[1].new_plant(:corn)
          params[0].text = "You planted SAPPHIRE CORN"
          }, params: [@message, @player.facing_tile] },
        { print: "Plant Pumpkin", block: lambda {
          |params| params[1].new_plant(:pumpkin)
          params[0].text = "You planted EMERALD PUMPKIN"
          }, params: [@message, @player.facing_tile] },
        { print: "Plant Tomato", block: lambda {
          |params| params[1].new_plant(:tomato)
          params[0].text = "You planted AMETHYST TOMATO"
          }, params: [@message, @player.facing_tile] },
        { print: "Cancel", block: lambda {
          |params| params[0].mode = :field
          }, params: [@window] } ],
      map_menu: [
        { print: "Energy", block: lambda {
          |params| params[0].text = "You have #{params[1]} left today."
          }, params: [@message, @player.energy] },
        { print: "Laugh", block: lambda {
          |params| params[0].text = "you are a lonely farmer and sit laughing by yourself until you cry it is really sad"
          }, params: [@message] },
        { print: "Exit Game", block: lambda {
          |params| params[0].text = "in beta, sorry d00d"
          }, params: [@message] },
        { print: "Cancel", block: lambda {
          |params| params[0].mode = :field
          }, params: [@window] } ],
          # |menu2| menu2.items = :exit_confirm_menu
        # }, params: [@menu2] } ],
      exit_confirm_menu: [
        { print: "Yes", block: lambda {
          |params| params[0].close_game
          }, params: [@window] },
        { print: "No", block: lambda {
          |params| params[0].close
          }, params: [@menu] } ]  
    }
  end
end

# { print: "XX", block: lambda {
#       |params| params[INDEX].COMMAND
#       }, params: [] }