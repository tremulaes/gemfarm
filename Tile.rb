class Tile
	attr_reader :x, :y, :tile_id
	attr_accessor :collidable, :holding

	def initialize(tile_hash)
		@window = tile_hash[:window]
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

	def new_plant(type)
		crop_hash = {
			window: @window,
      x: @x,
      y: @y,
      type: type,
      tile: self,
      menu: @menu
  	}
		@holding = Crop.new(crop_hash)
	end

	def collidable?
		@collidable
	end

	def draw(x, y)
		@img.draw(x, y, 0, 4, 4)
		@holding.draw(x, y) if @holding
	end
end