class Tile
	attr_reader :x, :y, :tile_id
	attr_accessor :collidable

	def initialize(tile_hash)
		@x = tile_hash[:x]
		@y = tile_hash[:y]
		@collidable = tile_hash[:collidable]
		@img = tile_hash[:img]
		@tile_id = tile_hash[:id]
	end

	def collidable?
		@collidable
	end

	def draw
		@img.draw(@x, @y, 0, 4, 4)
	end

end