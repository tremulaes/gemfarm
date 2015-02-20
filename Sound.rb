class Sound
  def initialize(window)
    @window = window
    load_songs
    @current_song = @early_farming
    @current_song.play(true)
    load_sounds
    @effect = :none
    @bgm_vol = 1.0
    @queue = []
  end

  def update
    queue_handle
    case @effect
    when :fade_out then @bgm_vol >= 0 ? @bgm_vol -= 0.005 : @effect = :none
    when :fade_in then @bgm_vol <= 1 ? @bgm_vol += 0.005 : @effect = :none
    when :change_song
      @current_song.stop
      @current_song == @early_farming ? @current_song = @late_farming : @current_song = @early_farming
      @current_song.play(true)
      @effect = :none
    end
    @current_song.volume = @bgm_vol
  end

  def queue_handle
    @effect = @queue.shift if !@queue.empty? && @effect == :none
  end

  def effect(*effect)
    effect.each { |effect| @queue << effect}
  end

  def day_pass(day)
    if day == 1 || day == 16
      effect(:fade_out, :change_song, :fade_in)
    end
  end

  def load_songs
    @early_farming = Gosu::Song.new(@window, "media/sound/farming.wav")
    @late_farming = Gosu::Song.new(@window, "media/sound/farming.wav")
  end

  def load_sounds
    @fx_accept = Gosu::Sample.new(@window, "media/sound/accept.wav")
    @fx_bubble = Gosu::Sample.new(@window, "media/sound/bubble.wav")
    @fx_close_menu = Gosu::Sample.new(@window, "media/sound/close_menu.wav")
    @fx_collision = Gosu::Sample.new(@window, "media/sound/collision.wav")
    @fx_open_menu = Gosu::Sample.new(@window, "media/sound/open_menu.wav")
    @fx_reject = Gosu::Sample.new(@window, "media/sound/reject.wav")
    @fx_scrolling_text = Gosu::Sample.new(@window, "media/sound/scrolling_text.wav")
    @fx_start_time = 0
    @fx_interval = 0
    @fx_vol = 1.0
  end

  def fx_timer
    @fx_interval < (Gosu::milliseconds - @fx_start_time).abs
  end

  def fx(key)
    if fx_timer
    @current
      case key
      when :accept
        @fx_accept.play(@fx_vol)
        @fx_interval = 0
      when :bubble
        @fx_bubble.play(@fx_vol)
        @fx_interval = 0
      when :close_menu
        @fx_close_menu.play(@fx_vol * 0.7)
        @fx_interval = 0
      when :collision
        @fx_collision.play(@fx_vol)
        @fx_interval = 700
      when :open_menu
        @fx_open_menu.play(@fx_vol * 0.7)
        @fx_interval = 0
      when :reject
        @fx_reject.play(@fx_vol)
        @fx_interval = 0
      when :text
        @fx_scrolling_text.play(@fx_vol * 0.8)
        @fx_interval = 1100
      end
      @fx_start_time = Gosu::milliseconds
    end
  end
end