class Tile
	attr_reader :x, :y, :tile_id
	attr_accessor :collidable, :holding

	def initialize(tile_hash)
		@x = tile_hash[:x]
		@y = tile_hash[:y]
		@collidable = tile_hash[:collidable]
		@img = tile_hash[:img]
		@tile_id = tile_hash[:id]
		@map = tile_hash[:map]
		@menu = tile_hash[:menu]
		@holding
	end

	def touch
		if @holding
			@holding.touch
		elsif @tile_id == 2
			@menu.items = EMPTY_FIELD_MENU
		end
	end

	def new_plant
		crop_hash = {
      x: @x,
      y: @y,
      type: 'corn',
      map: @map,
      menu: @menu
  	}
		@map.set_crop(crop_hash)
	end

	def collidable?
		@collidable
	end

	def draw
		@img.draw(@x, @y, 0, 4, 4)
	end
end