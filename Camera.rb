class Camera
  def initialize(window, map)
    @window = window
    @x = @y = 0
    @count = 0
  end

  def update(x, y)
    @x = x % 64 - 64
    @y = y % 64 - 64
  end

  def draw(view_array,tile_array)
    view_array.each_with_index do |subarray, yind|
      subarray.each_with_index do |cell, xind|
        if cell[0] && cell[1]
          tile_array[cell[1]][cell[0]].draw2(xind * 64 - @x - 128, yind * 64 - @y - 128)
        end
      end
    end
  end
end