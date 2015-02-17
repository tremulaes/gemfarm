require_relative 'MapData'
require_relative 'Tile'

class Map
  attr_reader :tile_array, :def_img

  def initialize(window, menu, array, *def_img_id)
    @map_array = array
    @scale = 4
    @window = window
    @menu = menu
    @tileset = Gosu::Image::load_tiles(window, "media/tileset/map_tileset.png", 16, 16, true)
    @def_img = def_img_id[0] ? @tileset[def_img_id[0]] : nil
    @tile_array = Array.new(@map_array.size) { Array.new(@map_array[0].size) }
    set_tiles
    @show_tiles = Array.new(13) { Array.new(13) }
    @h = @tile_array.size
    @w = @tile_array[0].size
  end

  def set_tiles
    @map_array.each_with_index do |subarray, y_index|
      subarray.each_with_index do |cell, x_index|
        tile_hash = {
          x: x_index * 64,
          y: y_index * 64,
          collidable: MAP_COLL.include?(cell),
          img: @tileset[cell],
          menu: @menu,
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
  end

  def crop_die(x,y)
    crop_object_id = tile_at(x,y).holding.object_id
    tile_at(x,y).holding = nil
  end

  def tile_num_at(x, y)
    coords = [x / 64, y / 64]
    coords
  end

  def tile_at(x, y)
    @tile_array[y / 64][x / 64]
  end

  def show_tiles(x,y)
    calc_show_tiles(x,y)
    @show_tiles
  end

  def calc_show_tiles(x, y)
    x1 = tile_at(x, y).x / 64
    y1 = tile_at(x, y).y / 64
    x_slice = ((x1 - 6)..(x1 + 6)).to_a
    y_slice = ((y1 - 6)..(y1 + 6)).to_a
    x_slice.map! { |i| i < 0 || i + 1 > @w ? i = nil : i }
    y_slice.map! { |i| i < 0 || i + 1 > @h ? i = nil : i }
    y_slice.each_with_index do |yline, yind|
      x_slice.each_with_index do |xrow, xind|
        @show_tiles[yind][xind] = [xrow, yline]
      end
    end
  end
end