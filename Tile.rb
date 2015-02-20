class Tile
	attr_reader :x, :y, :tile_id
	attr_accessor :collidable, :holding
	@@all_crops = Array.new

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

	def self.all_crops
		@@all_crops
	end

	def touch
		if @holding
			@holding.touch
		end
	end

	def walk_on
		if @holding
			@holding.walk_on
		end
	end

	def new_crop(type)
		crop_hash = {
			window: @window,
      type: type
    }
		@holding = Crop.new(crop_hash)
    @collidable = true
		@@all_crops << @holding
	end

	def kill_crop
		@@all_crops.delete_if {|item| item.object_id == @holding.object_id }
		@collidable = false
		@holding = FieldTile.new(@window)
	end

  def new_event(type, param = nil)
    case type
    when :warp then @holding = Warp.new(@window, param)
    when :textevent then @holding = TextEvent.new(@window, param)
    when :bed then 
      @holding = Bed.new(@window)
    end
  end

	def draw(x, y)
		@img.draw(x, y, 0, 4, 4)
		@holding.draw(x, y) if @holding
	end
end