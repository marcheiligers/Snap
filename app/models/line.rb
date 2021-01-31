class Snap
  class Line
    attr_accessor :x1, :y1, :x2, :y2, :color, :width

    def self.simple(x1, y1, x2, y2)
      new(x1: x1, y1: y1, x2: x2, y2: y2)
    end

    def initialize(x1: 0, y1: 0, x2: 0, y2: 0, color: [0, 0, 0, 255], width: 1)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
      @color = color
      @width = width
    end

    def draw(stage, gc)
      gc.line_attributes = Gfx.LineAttributes.new(width)
      gc.foreground = Gfx.Color.new(gc.device, *color)
      gc.draw_line(x1, y1, x2, y2)
    end
  end
end
