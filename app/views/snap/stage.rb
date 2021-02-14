require_relative '../../models/sprite'
require_relative '../../models/line'
require_relative '../../models/string'
require_relative '../../models/oval'
require_relative '../../models/circle'

class Snap
  class Stage
    attr_reader :turtle, :canvas, :parent, :drawables, :actors

    SIZE = 1_000.0 # Stage is a 1,000px square

    def initialize(parent)
      @parent = parent

      composite = Swt::Widgets::Composite.new(parent, 0)
      layout = Swt::Layout::FillLayout.new
      layout.marginWidth = 4
      layout.marginHeight = 4
      composite.layout = layout
      composite.background = Config.instance.theme.background

      @canvas = Swt::Widgets::Canvas.new(composite, 0)
      canvas.background = Config.instance.theme.background

      canvas.add_paint_listener do |e|
        paint_background(e.gc)
        transformed(e.gc) do |gc|
          drawables.each { |d| d.draw(self, gc) }
          actors.each { |a| a.draw(self, gc) }
        end
      end

      @turtle = Sprite.new(parent.display, 'turtle', x: 500, y: 500, size: 10)
      reset
    end

    def add_drawable(drawable)
      drawables << drawable
    end

    def add_actor(actor)
      drawables << actor
    end

    def clear
      @drawables = []
      @actors = [turtle]
    end

    def zoom
      rc = client_area
      (rc.width > rc.height ? rc.height : rc.width) / SIZE
    end

    def client_area
      canvas.client_area
    end

    def paint
      parent.display.sync_exec { canvas.redraw }
    rescue => e
      puts e.full_message
    end

    def reset
      clear
      turtle.goto(500, 500)
      turtle.face(0)
      turtle.show_turtle
      turtle.pen_size 1
      turtle.pen_color 0, 0, 0
      turtle.pen_down

      # Add a grid
      # [250, 500, 750].each do |grid|
      #   add(Line.simple(grid, 0, grid, 1000))
      #   add(Line.simple(0, grid, 1000, grid))
      # end
    end

    def paint_background(gc)
      rc = client_area

      gc.foreground = Gfx.Color.new(36, 36, 36)
      gc.background = Gfx.Color.new(255, 255, 255)

      if rc.width > rc.height
        gc.fill_rectangle(0, 0, rc.height, rc.height)
        gc.draw_rectangle(0, 0, rc.height - 1, rc.height - 1)
      else
        gc.fill_rectangle(0, 0, rc.width, rc.width)
        gc.draw_rectangle(0, 0, rc.width - 1, rc.width - 1)
      end
    end

    def transformed(gc)
      gc.advanced = true
      puts 'Advanced graphics not supported' and return unless gc.advanced?

      old_transform = Gfx.Transform.new(gc.device)
      gc.get_transform(old_transform)

      transform = Gfx.Transform.new(gc.display)
      transform.scale(zoom, zoom)

      gc.set_transform(transform)
      yield gc
    rescue => e
      puts e.full_message
    ensure
      gc.set_transform(old_transform)
      transform.dispose
    end
  end
end