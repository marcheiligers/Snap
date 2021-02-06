class Snap
  class Sprite
    module Drawing
      attr_reader :pen_is_up
      alias_method :pen_up?, :pen_is_up

      def init_drawing(size: 1, color: [0, 0, 0, 255], up: false)
        @pen_size = size
        @pen_color = color
        @pen_is_up = up
      end

      def pen_up
        @pen_up = true
      end
      alias_method :pu, :pen_up

      def pen_down
        @pen_up = false
      end
      alias_method :pd, :pen_down

      def pen_size(size = nil)
        if size
          @pen_size = size
        else
          @pen_size
        end
      end
      alias_method :ps, :pen_size

      def pen_color(*args) # nothing (reader), color_name, or r, g, b, a = 255
        # TODO: support named colors
        if args.length == 0
          @pen_color
        else
          @pen_color = *args + Array.new(4 - args.length, 255)
        end
      end
      alias_method :pc, :pen_color
    end
  end
end