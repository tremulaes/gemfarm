class Bed
  def initialize(window)
    @window = window
    calc_menu
  end

  def calc_menu
    @bed_confirm_menu = [
      { print: "Very Sure", block: lambda { |params|
        params[:window].calendar.day_pass
      } },
      { print: "Not yet", block: lambda { |params|
        params[:menu].close
      } } ]
    @bed_menu = [
      { print: "Yes", block: lambda { |params|
        if params[:player].energy == params[:player].max_energy
          params[:menu].use_sub_menu(:sub_menu1, @bed_confirm_menu)
          params[:message].show_text("You haven't done much today, are you sure you want to sleep?", true)
        else
          params[:window].calendar.day_pass
        end
      } },
      { print: "No", block: lambda { |params|
        params[:menu].close
      } } ]
  end

  def touch
    @window.show_prompt(@bed_menu, "Are you ready to sleep?")
  end

  def walk_on
  end

  def draw(x,y)
  end
end