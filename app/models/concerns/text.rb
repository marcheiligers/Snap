require_relative 'font'

class Snap
  class Sprite
    module Text
      attr_reader :font_name, :font_size

      def init_text(font_name: 'serif', font_size: 15)
        set_font(font_name, font_size)
      end

      def set_font(name, size = 15)
        @font_name = name
        @font_size = size
      end

      def write(string, stage) # HACK: Executor passes the stage
        string = Snap::String.new(
          string: string,
          x: x,
          y: y,
          font_name: font_name,
          font_size: font_size,
          color: pen_color,
          direction: direction
        )

        dist, _ = string.measure(stage)
        @x = x + dist * Math.sin(rad)
        @y = y - dist * Math.cos(rad)

        string unless pen_up?
      end
    end
  end
end
