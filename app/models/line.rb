class Line
  # TODO: apply stage zoom

  attr_accessor :x1, :y1, :x2, :y2, :color, :width

  Gfx = org.eclipse.swt.graphics

  def self.simple(x1, y1, x2, y2)
    new(x1: x1, y1: y1, x2: x2, y2: y2)
  end

  def initialize(x1: 0, y1: 0, x2: 0, y2: 0, color: :black, width: 1)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
    @color = color
    @width = width
  end

  def draw(stage, gc)
    transformed(gc, stage.zoom) do
      gc.draw_line(x1, y1, x2, y2)
    end
  end

  private

  def transformed(gc, zoom)
    old_transform = Gfx.Transform.new(gc.device)
    gc.get_transform(old_transform)

    transform = Gfx.Transform.new(gc.display)
    transform.scale(zoom, zoom)

    gc.set_transform(transform)
    yield
  ensure
    gc.set_transform(old_transform)
    transform.dispose
  end
end