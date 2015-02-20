class TextEvent
  def initialize(window, text)
    @window = window
    @text = text
    @draw = false
  end

  def touch
    @window.show_message(@text)
  end

  def walk_on
  end

  def draw(x,y)
  end
end