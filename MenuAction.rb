module MenuAction
  # def menu_act(action, arg_hash)
  #   crop = arg_hash[:crop] ||= nil
  #   tile = arg_hash[:tile] ||= nil
  #   energy = arg_hash[:energy] ||= nil
  #   map_id = arg_hash[:map_id] ||= nil
  #   case action
  #   when :cancel
  #     @window.fx(:close_menu)
  #     close_menu
  #     @action = :none
  #   when :dance
  #     @message.text = "you danced with the crop but it's really hard to say why you would think that's a good idea."
  #     @action = :none
  #   when :energy
  #     @message.text = "You have #{energy} left today."
  #     @action = :none
  #   when :exit
  #     self.items = EXIT_CONFIRM_MENU
  #     @message.text = "Are you sure you want to leave?"
  #     @action = :none
  #     self.show = :continue
  #   when :exit_yes
  #     @window.fx(:accept)
  #     @window.close_game
  #   when :exit_no
  #     @window.fx(:reject)
  #     close_menu
  #     @action = :none
  #   when :kick
  #     crop.die
  #     @message.text = "You are a meanie you killed the crop"
  #     @action = :none
  #   when :laugh
  #     @message.text = "you are a lonely farmer and sit laughing by yourself until you cry it is really sad"
  #     @action = :none
  #   when :plant_corn
  #     @window.fx(:accept)
  #     tile.new_plant(:corn)
  #     @message.text = "You planted SAPPHIRE CORN"
  #     @action = :none
  #   when :plant_pumpkin
  #     @window.fx(:accept)
  #     tile.new_plant(:pumpkin)
  #     @message.text = "You planted EMERALD PUMPKIN"
  #     @action = :none
  #   when :plant_tomato
  #     @window.fx(:accept)
  #     tile.new_plant(:tomato)
  #     @message.text = "You planted AMETHYST TOMATO"
  #     @action = :none
  #   when :warp
  #     @message.text = "What, you think you can teleport? You're a farmer, not an X-man."
  #     @action = :none
  #   when :water
  #     @window.fx(:bubble)
  #     crop.grow
  #     @action = :none
  #   end
  #   self.show = :false if self.show != :continue
  # end

  # def close_menu
  #   self.show = :false
  #   @message.show = :false
  # end

  # def calc_menu_act_hash
  #   key_array = []
  #   @items.each {|item| key_array << item.keys[0]}
  #   if key_array.include?(:water) || key_array.include?(:kick)
  #     @menu_act_hash[:crop] = @window.player.facing_tile.holding
  #   end
  #   if key_array.include?(:plant_corn) || key_array.include?(:plant_tomato) || key_array.include?(:plant_pumpkin)
  #     @menu_act_hash[:tile] = @window.player.facing_tile
  #   end
  #   if key_array.include?(:energy)
  #     @menu_act_hash[:energy] = @window.player.energy
  #   end
  # end

  def calc_menu
    @menus = {
      crop_menu: [
        { print: "Water", block: lambda { 
          |params| params[0].fx(:bubble); params[1].grow 
          }, params: [@window, @player.facing_tile.holding] },
        { print: "Dance", block: lambda {
          |params| params[0].text = "you danced with the crop but it's really hard to say why you would think that's a good idea."
          }, params: [@message] },
        { print: "Kick", block: lambda {
          |params| params[1].die; params[0].text = "You are a meanie you killed the crop"
          }, params: [@message, @player.facing_tile.holding] } ],
      field_menu: [
        { print: "Plant Corn", block: lambda {
          |params| params[0].new_plant(:corn)
          }, params: [@player.facing_tile] },
        { print: "Plant Pumpkin", block: lambda {
          |params| params[0].new_plant(:pumpkin)
          }, params: [@player.facing_tile] },
        { print: "Plant Tomato", block: lambda {
          |params| params[0].new_plant(:tomato)
          }, params: [@player.facing_tile] } ],
      map_menu: [
        { print: "Energy", block: lambda {
          |params| params[0].text = "You have #{params[1]} left today."
          }, params: [@message, @player.energy] },
        { print: "Laugh", block: lambda {
          |params| params[0].text = "you are a lonely farmer and sit laughing by yourself until you cry it is really sad"
          }, params: [@message] },
        { print: "Exit", block: lambda {
          |params| params[0].text = "in beta, sorry d00d"
          }, params: [@message] } ],
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

# CROP_MENU = [{ water: "Water"}, { dance: "Dance"}, { kick: "Kick" }]
# EMPTY_FIELD_MENU = [{ plant_corn: "Plant Corn"}, { plant_pumpkin: "Plant Pumpkin"}, { plant_tomato: "Plant Tomato"}]
# MAP_SCREEN_MENU = [{ energy: "Energy" }, { laugh: "Laugh" }, { warp: "Warp" }, { exit: "Exit"}]
# EXIT_CONFIRM_MENU = [{ exit_yes: "Yes"}, exit_no: "No"]

# { print: "XX", block: lambda {
#       |params| params[INDEX].COMMAND
#       }, params: [] }