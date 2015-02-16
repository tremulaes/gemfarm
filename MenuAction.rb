module MenuAction
  def menu_act(action, arg_hash)
    crop = arg_hash[:crop] ||= nil
    tile = arg_hash[:tile] ||= nil
    case action
    when :cancel
      self.show = false
    when :water
      crop.grow
    when :kick
      crop.die
      @message.text = "You are an asshole you killed the crop"
    when :plant
      tile.new_plant
      @message.text = "You planted SAPPHIRE CORN"
    when :laugh
      @message.text = "you are a lonely farmer and sit laughing until you cry it is really sad"
    end
    self.show = false
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
  end
end