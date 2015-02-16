module MenuAction
  def menu_act(action, arg_hash)
    crop = arg_hash[:crop] ||= nil
    tile = arg_hash[:tile] ||= nil
    energy = arg_hash[:energy] ||= nil
    case action
    when :cancel
      @window.fx(:close_menu)
      close_menu
    when :exit
      self.items = EXIT_CONFIRM_MENU
      @message.text = "Are you sure you want to leave?"
      self.show = :continue
    when :exit_yes
      @window.fx(:accept)
      @window.close_game
    when :exit_no
      @window.fx(:reject)
      close_menu
    when :energy
      @message.text = "You have #{energy} left today."
    when :water
      @window.fx(:bubble)
      crop.grow
    when :kick
      crop.die
      @message.text = "You are an asshole you killed the crop"
    when :plant
      @window.fx(:accept)
      tile.new_plant
      @message.text = "You planted SAPPHIRE CORN"
    when :laugh
      @message.text = "you are a lonely farmer and sit laughing by yourself until you cry it is really sad"
    when :dance
      @message.text = "you danced with the crop but it's really hard to say why you would think that's a good idea."
    end
    self.show = :false if self.show != :continue
  end

  def close_menu
    self.show = :false
    @message.show = :false
  end

  def calc_menu_act_hash
    key_array = []
    @items.each {|item| key_array << item.keys[0]}
    if key_array.include?(:water) || key_array.include?(:kick)
      @menu_act_hash[:crop] = @window.ruby.facing_tile.holding
    end
    if key_array.include?(:plant)
      @menu_act_hash[:tile] = @window.ruby.facing_tile
    end
    if key_array.include?(:energy)
      @menu_act_hash[:energy] = @window.ruby.energy
    end
  end
end