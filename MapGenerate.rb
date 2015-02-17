# @maps is a hash; key = map name, value is an array with relevant data
# array[0] = map object
# array[1] = default warp coordinates [x,y] format
# array[2] = default image for outside tiles; default to nil if black is desired
# array[2] = hash array for default object instantiation [{type: [x,y]}, {type: [x,y]}]

module MapGenerate

  def generate_maps
    @maps = { 
      farm: [Map.new(self, @menu, FARM_MAP_ARRAY,1), [8,3]],
      big: [Map.new(self, @menu, BIG_MAP_ARRAY,0), [4,5]],
      home: [Map.new(self, @menu, HOME_MAP_ARRAY), [3,2]]
    }
  end
end