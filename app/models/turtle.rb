class Turtle < Sprite
  attr_reader :stage, :pen_up, :color

  alias_method :pen_up?, :pen_up

  def initialize(display, stage)
    super(display, 'turtle', x: 500, y: 500, r: 0, z: 20)
    @stage = stage
    @pen_up = false
  end

  def rt(angle)
    log "Turtle#rt(#{angle})"
    turn(angle)
  end

  def lt(angle)
    log "Turtle#lt(#{angle})"
    turn(-angle)
  end

  def up(dist)
    log "Turtle#up(#{dist})"
    line = Line.simple(x, y, x, y - dist)
    stage.add(line) unless pen_up?
    goto(x, y - dist)
  end

  def run(code)
    log '-' * 100
    log code
    log '-' * 100
    eval code
  rescue => e
    puts e.message
    puts e.backtrace
  end

  def log(msg)
    puts msg
  end
end