require_relative 'drawable'

class Snap
  class String < Drawable
    include Font

    attr_accessor :string, :x, :y, :font_name, :font_size, :color, :direction

    DRAW_STYLE = Swt::SWT::DRAW_DELIMITER | Swt::SWT::DRAW_TAB | Swt::SWT::DRAW_TRANSPARENT

    def initialize(string:, x: 0, y: 0, font_name: 'serif', font_size: 15, color: [0, 0, 0, 255], direction: 0)
      @string = string
      @x = x
      @y = y
      @font_name = font_name
      @font_size = font_size
      @color = color
      @direction = direction
    end

    def draw(stage, gc)
      @col ||= Gfx.Color.new(gc.device, *color)
      @font ||= Gfx.Font.new(gc.device, find_font(gc.device, font_name), font_size, Swt::SWT::NORMAL)

      gc.font = @font
      gc.foreground = @col
      rotation_transform(gc) do
        pt = gc.text_extent(string, DRAW_STYLE)
        gc.draw_text(string, x, y - pt.y / 2, DRAW_STYLE)
      end
    end

    def measure(stage)
      pt = nil

      stage.parent.display.sync_exec do
        gc = Gfx.GC.new(stage.canvas);

        @font ||= Gfx.Font.new(gc.device, find_font(gc.device, font_name), font_size, Swt::SWT::NORMAL)

        gc.font = @font
        pt = gc.text_extent(string, DRAW_STYLE)
      rescue => e
        puts e.full_message
      ensure
        gc.dispose if gc
      end

      [pt.x, pt.y]
    end

    def rotation_transform(gc)
      old_transform = Gfx.Transform.new(gc.device)
      gc.get_transform(old_transform)

      elements = Java::float[6].new
      old_transform.get_elements(elements)

      transform = Gfx.Transform.new(gc.device, *elements)
      transform.translate(x, y)
      transform.rotate(direction - 90)
      transform.translate(-x, -y)

      gc.set_transform(transform)
      yield
    rescue => e
      puts e.full_message
    ensure
      gc.set_transform(old_transform)
      transform.dispose
    end
  end
end
