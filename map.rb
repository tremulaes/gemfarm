require_relative 'mapdata'

class Map
  def initialize(window, array)
    @map_array = array
    @scale = 4
    @tileset = Gosu::Image::load_tiles(window, "media/tileset/map_tileset.png", 16, 16, true)
  end

  def draw
    @map_array.each_with_index do |subarray, y_index|
      subarray.each_with_index do |cell, x_index|
        img = @tileset[cell]
        img.draw((x_index * 64) + 0, (y_index * 64) + 0, 0, @scale, @scale)
      end
    end
  end
end