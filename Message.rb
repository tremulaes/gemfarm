class Message
  attr_accessor :show

  def initialize(window)
    @window = window
    @x, @y, @w, @h, @b = 0, 500, 960, 140, 5
    @black, @white = 0xff000000, 0xffffffff
    @font = Gosu::Font.new(@window, "Courier", 15)
    @text = ""
    @line_array = []
    @show_line = []
    @show_index
    @show = false
    @next_line = false
  end

  def text=(new_text) #must be string!
    @text = new_text.clone
    @line_array.clear
    line_slicer(new_text)
    if @line_array.size > 1
      @show_line = @line_array[0..1]
      @next_line = true if @line_array.size >= 3
    else
      @show_line = @line_array.clone
    end
    @show_index = 0
    @show = true
  end

  def line_slicer(new_text)
    while new_text.size >= 34
      @line_array << new_text.slice!(0..33)
    end
    @line_array << new_text
  end

  def interact
    puts "#{@next_line}: #{@show_line}"
    if @next_line
      @show_index += 1
      @show_line = @line_array[@show_index..@show_index + 1]
      @next_line = false if @line_array.size - @show_index <= 2
    else
      @show = false
    end
  end

  def draw
    if @show == true
      @window.draw_quad(@x, @y, @black, @x + @w, @y, @black, @x, @y + @h, @black, @x + @w, @y + @h, @black, 4) #black box
      @window.draw_quad(@x + @b, @y + @b, @white, @x + @w - @b, @y + @b, @white, @x + @b, @y + @h - @b, @white, @x + @w - @b, @y + @h - @b, @white, 5) # white box
      @show_line.each_with_index do |line, index|
        @font.draw("#{line}", @x + 35 , @y + 15 + (index * 64), 6, 4.0, 4.0, @black)
      end
    end
  end
end