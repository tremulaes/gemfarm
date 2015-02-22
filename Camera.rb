require_relative 'CameraAction'
# @black = 0xff000000 # black
# @white = 0xffffffff # white

class Camera
  include CameraAction

  def initialize(window, map)
    @window = window
    @w = 704
    @x = @y = 0
    @queue = []
    @effect = :none
    @timer = 0
    @change_color 
    @final_color
  end

  def update(x, y)
    @x = x % 64 - 64
    @y = y % 64 - 64
    effect_timer
  end

  def effect_timer
    if @effect == :none
      effect(@queue.shift) if @queue.size > 0
    else
      case @effect
      when :fade_out #26 ticks
        if @change_color <= @final_color
          @change_color += 16777216 * 8 # 1/256 for alpha column!
        else
          @effect = :none
        end
      when :fade_in #27 ticks
        if @change_color >= @final_color
          @change_color -= 16777216 * 8 # 1/256 for alpha column!
        else
          @effect = :none
        end
      when :white_fade #27 ticks
        if @change_color >= @final_color
          @change_color -= 16777216 * 8 # 1/256 for alpha column!
        else
          @effect = :none
        end
      end
    end
  end

  def draw(viewport, tile_array, def_img)
    viewport.each_with_index do |subarray, yind|
      subarray.each_with_index do |cell, xind|
        if cell[0] && cell[1]
          tile_array[cell[1]][cell[0]].draw(xind * 64 - @x - 128, yind * 64 - @y - 128)
        elsif def_img
          def_img.draw(xind * 64 - @x - 128, yind * 64 - @y - 128, 0, 4, 4)
        end
      end
    end
    if @effect != :none
      case @effect
      when :fade_out
        draw_fade
      when :fade_in
        draw_fade
      when :white_fade
        draw_fade
      end
    end
  end
end