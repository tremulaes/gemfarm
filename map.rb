require_relative 'mapdata'
require_relative 'Tile'

class Map
  attr_reader :tile_array, :crop_array

  def initialize(window, array)
    @map_array = array
    @scale = 4
    @window = window
    @tileset = Gosu::Image::load_tiles(window, "media/tileset/map_tileset.png", 16, 16, true)
    @tile_array = Array.new(10) { Array.new(15) }
    set_tiles
    @crop_array = []
  end

  def set_tiles
    @map_array.each_with_index do |subarray, y_index|
      subarray.each_with_index do |cell, x_index|
        tile_hash = {
          x: x_index * 64,
          y: y_index * 64,
          collidable: MAP_COLL.include?(cell),
          img: @tileset[cell],
          id: cell,
          map: self
        }
        @tile_array[y_index][x_index] = Tile.new(tile_hash)  
      end
    end    
  end

  def set_crop(crop_hash)
    if !crop_hash.include?(:window)
      crop_hash[:window] = @window
    end
    tile_at(crop_hash[:x], crop_hash[:y]).holding = Crop.new(crop_hash)
    @crop_array << tile_at(crop_hash[:x], crop_hash[:y]).holding
  end

  def tile_num_at(x, y)
    coords = [x / 64, y / 64]
    coords
  end

  def tile_at(x, y)
    @tile_array[y / 64][x / 64]
  end

  def draw
    @tile_array.each_with_index do |subarray, y_index|
      subarray.each_with_index do |cell, x_index|
        @tile_array[y_index][x_index].draw
      end
    end
  end
end