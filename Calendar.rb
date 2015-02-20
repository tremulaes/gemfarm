class Calendar
  attr_reader :day

  def initialize(window)
    @window = window
    @day = 1
  end

  def day_pass
    @day += 1
    Tile.all_crops.each { |crop| crop.day_pass }
    @window.player.day_pass
  end
end