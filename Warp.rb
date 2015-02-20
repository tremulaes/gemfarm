class Warp
  def initialize(window, warp_hash)
    @window = window
    @warp_x = warp_hash[:warp_x]
    @warp_y = warp_hash[:warp_y] 
    @warp_map_id = warp_hash[:map_id]
    @direction = warp_hash[:direction] ||= :down
    @draw = false
  end

  def touch
  end

  def walk_on
    change_map_hash = {
      warp_map_id: @warp_map_id,
      warp_x: @warp_x, 
      warp_y: @warp_y,
      direction: @direction
    }
    @window.effect(:fade_out)
    @window.change_map(change_map_hash)
  end

  def draw(x,y)
  end
end