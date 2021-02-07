require_relative 'drawable'

class Snap
  class Oval < Drawable
    attr_accessor :x, :y, :w, :h, :start, :arc, :color, :width

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

      # https://javadoc.scijava.org/Eclipse/org/eclipse/swt/graphics/GC.html#drawArc(int,int,int,int,int,int)
      # Angles are interpreted such that 0 degrees is at the 3 o'clock position. A positive value indicates a
      #   counter-clockwise rotation while a negative value indicates a clockwise rotation.
      gc.draw_arc(x, y, w, h, 180 - start, -arc)
    end
  end
end
