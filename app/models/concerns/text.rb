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

      def write(string)
        # TODO: measure string and move
        Snap::String.new(
          string: string,
          x: x,
          y: y,
          font_name: font_name,
          font_size: font_size,
          color: pen_color,
          direction: direction
        ) unless pen_up?
      end
    end
  end
end
