# @maps is a hash; key = map name, value is an array with relevant data
# array[0] = map objects
# array[1] = default warp coordinates

module MapGenerate
  def generate_maps
    @maps = { 
      home: [Map.new(self, @menu, HOME_MAP_ARRAY),[8,3]],
      big: [Map.new(self, @menu, BIG_MAP_ARRAY),[4,5]]
    }
  end
end