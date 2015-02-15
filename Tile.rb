class Tile
	attr_reader :x, :y, :collidable

	def initialize(tile_hash)
		@x = tile_hash[:x]
		@y = tile_hash[:y]
		@collidable = tile_hash[:collidable]
		@img = tile_hash[:img]
	end

	def draw
		@img.draw(@x, @y, 0, 4, 4)
	end

end