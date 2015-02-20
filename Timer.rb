class Timer
  attr_reader :waiting

  def initialize
    @timer, @waiting = 0, false
  end

  def set_timer(frames)
    @timer = frames if frames > @timer
    update
  end

  def update
    if @timer > 0
      @waiting = true
      @timer -= 1  
    else
      @waiting = false
    end
  end
end