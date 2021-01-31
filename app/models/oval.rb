class Snap
  class Oval
    attr_accessor :x, :y, :w, :h, :start, :arc, :color, :width

    def self.simple(x1, y1, x2, y2)
      new(x1: x1, y1: y1, x2: x2, y2: y2)
    end

    def initialize(x: 0, y: 0, w: 0, h: 0, start: 0, arc: 360, color: [0, 0, 0, 255], width: 1)
      @x = x
      @y = y
      @w = w
      @h = h
      @start = start
      @arc = arc
      @color = color
      @width = width
    end

    def draw(stage, gc)
      gc.line_attributes = Gfx.LineAttributes.new(width)
      gc.foreground = Gfx.Color.new(gc.device, *color)
      gc.draw_arc(x, y, w, h, start, arc)
    end
  end
end
