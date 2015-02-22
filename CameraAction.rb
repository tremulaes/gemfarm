module CameraAction
  def effect(effect)
    if @effect == :none
      @effect = effect
      case @effect
      when :fade_out
        @final_color = 0xcc000000
        @change_color = 0x00000000
        @window.set_timer(30)
      when :fade_in
        @final_color = 0x00000000
        @change_color = 0xcc000000
        @window.set_timer(30)
      when :white_fade
        @final_color = 0x00FFFFFF
        @change_color = 0xFFFFFFFF
        @window.set_timer(60)
      end
    else
      @queue << effect
    end
  end

  def draw_fade
    @window.draw_quad(0, 0, @change_color, @w, 0, @change_color, 0, @w, @change_color, @w, @w, @change_color, 25)
  end
end