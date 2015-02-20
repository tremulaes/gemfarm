class Tile
	attr_reader :x, :y, :tile_id
	attr_accessor :collidable, :holding#, :all_crops
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
		calc_menu
		@holding
	end

	def self.all_crops
		@@all_crops
	end

	def touch
		if @holding
			@holding.touch
		elsif @tile_id == 2
			@window.show_menu(@field_tile_menu)
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
      x: @x,
      y: @y,
      type: type,
      tile: self,
      menu: @menu
  	}
		@holding = Crop.new(crop_hash)
		@@all_crops << @holding
	end

	def kill_crop
		@@all_crops.delete_if {|item| item.object_id == @holding.object_id }
		@collidable = false
		@holding = nil
	end

	def new_warp(warp_hash)
		@holding = Warp.new(@window, warp_hash)
	end

	def new_textevent(text)
		@holding = TextEvent.new(@window, text)
	end

	def collidable?
		@collidable
	end

	def calc_menu
		@field_plant_menu = [
      { print: "Plant Corn", block: lambda {
        |params| params[:player].facing_tile.new_crop(:corn)
        params[:message].set_text("You planted SAPPHIRE CORN"); params[:player].energy -= 1
        } },
      { print: "Plant Pumpkin", block: lambda {
        |params| params[:player].facing_tile.new_crop(:pumpkin)
        params[:message].set_text("You planted EMERALD PUMPKIN"); params[:player].energy -= 1
        } },
      { print: "Plant Tomato", block: lambda {
        |params| params[:player].facing_tile.new_crop(:tomato)
        params[:message].set_text("You planted AMETHYST TOMATO"); params[:player].energy -= 1
        } },
      { print: "Cancel", block: lambda {
        |params| params[:menu].close
        } } ]
		@field_tile_menu = [
      { print: "Hoe Soil", block: lambda {
        |params| params[:message].set_text("You hoed the soil vigorously. Good work. Seriously.")
      } },
      { print: "Plant", block: lambda {
        |params| params[:menu].use_sub_menu(:sub_menu1, @field_plant_menu)
        params[:message].set_text("What would you like to plant?", true)
      } },
      { print: "Cancel", block: lambda {
        |params| params[:menu].close
        } } ]
	end

	def draw(x, y)
		@img.draw(x, y, 0, 4, 4)
		@holding.draw(x, y) if @holding
	end
end