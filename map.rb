require_relative 'mapdata'
require_relative 'Tile'

class Map
  attr_reader :tile_array

  def initialize(window, array)
    @map_array = array
    @scale = 4
    @tileset = Gosu::Image::load_tiles(window, "media/tileset/map_tileset.png", 16, 16, true)
    @tile_array = Array.new(10) { Array.new(15) }
    set_tiles
  end

  def set_tiles
    @map_array.each_with_index do |subarray, y_index|
      subarray.each_with_index do |cell, x_index|
        tile_hash = {
          x: x_index * 64,
          y: y_index * 64,
          collidable: MAP_COLL.include?(cell),
          img: @tileset[cell]
        }
        @tile_array[y_index][x_index] = Tile.new(tile_hash)  
      end
    end    
  end

  def draw
    @tile_array.each_with_index do |subarray, y_index|
      subarray.each_with_index do |cell, x_index|
        @tile_array[y_index][x_index].draw
      end
    end
  end
end