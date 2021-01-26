class Turtle < Sprite
  attr_reader :stage, :pen_is_up, :color, :width, :thread

  alias_method :pen_up?, :pen_is_up

  def initialize(display, stage)
    super(display, 'turtle', x: 500, y: 500, r: 0, z: 20)
    @stage = stage
    @pen_is_up = false
    @color = [0, 0, 0, 255]
    @width = 1
  end

  def right(angle)
    turn(angle)
    wait(0.01)
  end
  alias_method :rt, :right

  def left(angle)
    turn(-angle)
    wait(0.01)
  end
  alias_method :lt, :left

  def forward(dist)
    x1 = x + dist * Math.sin(rad)
    y1 = y - dist * Math.cos(rad)
    stage.add(Line.new(x1: x, y1: y, x2: x1, y2: y1, color: color, width: width)) unless pen_up?
    goto x1, y1
    wait(0.01)
  end
  alias_method :fd, :forward

  def pen_up
    @pen_up = true
  end
  alias_method :pu, :pen_up

  def pen_down
    @pen_up = false
  end
  alias_method :pd, :pen_down

  def pen_size(size)
    @width = size
  end
  alias_method :ps, :pen_size

  def hide_turtle
    @visible = false
    stage.paint
  end
  alias_method :ht, :hide_turtle

  def show_turtle
    @visible = true
    stage.paint
  end
  alias_method :st, :show_turtle

  def pen_color(r, g, b, a = 255)
    @color = [r, g, b, a]
  end
  alias_method :pc, :pen_color

  def wait(time)
    stage.paint
    sleep time
  end
  alias_method :wt, :wait

  def run(code)
    return unless @thread.nil?

    @thread = Thread.new do
      sleep 0.1
      eval code
      @thread = nil
    end
  rescue => e
    puts e.full_message
  end

  def stop
    return if @thread.nil?

    @thread.kill
  rescue => e
    puts e.full_message
  ensure
    @thread = nil
  end
end
