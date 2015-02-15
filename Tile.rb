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
		@holding
	end

	def touch
		if @holding
			@holding.touch
			puts "Touch crop at #{@x}, #{@y}, tile_id: #{@tile_id}"
		elsif @tile_id == 2
			crop_hash = {
	      x: @x,
	      y: @y,
	      type: 'corn',
	      map: @map
    	}
			@map.set_crop(crop_hash)
			puts "Place crop at #{@x}, #{@y}, tile_id: #{@tile_id}"
		else
			puts "Do nothing at #{@x}, #{@y}, tile_id: #{@tile_id}"
		end
	end

	def collidable?
		@collidable
	end

	def draw
		@img.draw(@x, @y, 0, 4, 4)
	end
end