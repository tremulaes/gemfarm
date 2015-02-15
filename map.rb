class Map
  def initialize(array)
    @map_array = array
    @scale = 4
    @tileset = Gosu::Image::load_tiles(self, "media/map_tileset.png", 16, 16, false)
  end

  def draw
    @map_array.each_with_index |subarray, y_index| do
      subarray.each_with_index |cell, x_index| do
        img = tileset[y_index[x_index]]
        img.draw((x_index * @scale) + 1, (y_index * @scale) + 1, 0, 4, 4)
      end
    end
  end
end