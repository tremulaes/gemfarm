class Bed
  def initialize(window)
    @window = window
    calc_menu
  end

  def calc_menu
    @bed_menu = [
      { print: "Yes", block: lambda {
        |params| params[:window].calendar.day_pass
      } },
      { print: "No", block: lambda {
        |params| params[:menu].close
      } } ]
  end

  def touch
    @window.show_prompt(@bed_menu, "Are you sure you want to sleep?")
  end

  def walk_on
  end

  def draw(x,y)
  end
end