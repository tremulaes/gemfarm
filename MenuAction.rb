module MenuAction
  def menu_act(action, arg_hash)
    crop = arg_hash[:crop] ||= nil
    tile = arg_hash[:tile] ||= nil
    case action
    when :cancel
      self.show = false
    when :water
      crop.grow
    when :plant
      tile.new_plant
    end
    self.show = false
  end
end