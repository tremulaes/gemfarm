require_relative 'Crop'
require_relative 'SapphireCorn'
require_relative 'EmeraldPumpkin'
require_relative 'AmethystTomato'

class Tile
	attr_reader :x, :y, :tile_id
	attr_accessor :collidable, :holding
	@@all_crops = Array.new
  @@harvested_crops = Array.new

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

	def new_crop(type, img, state, name)
		crop_hash = {
			window: @window,
      type: type,
      field_image: img,
      field_state: state, 
      name: name
    }
    case type
    when :corn then @holding = SapphireCorn.new(crop_hash)
    when :pumpkin then @holding = EmeraldPumpkin.new(crop_hash)
    when :tomato then @holding = AmethystTomato.new(crop_hash)
    end
    @collidable = true
		@@all_crops << @holding
	end

	def erase_crop(reason = :kill)
    if reason == :harvest
      @@all_crops << @holding
    end
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