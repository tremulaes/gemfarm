class AmethystTomato < Crop
  def calc_special
    @special_crop_menu =[
      { print: "Default", block: lambda { |params| 
        params[:message].show_text("If this is showing something is wrong!")
      } },
      { print: "Cancel", block: lambda { |params| 
        params[:menu].close
        } } ]
  end

  def calc_happy
  end
end