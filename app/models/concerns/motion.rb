class Snap
  class Sprite
    attr_accessor :x, :y, :direction

    module Motion
      def init_motion(x: 500, y: 500, direction: 0)
        @x = x
        @y = y
        @direction = direction
      end

      def right(angle)
        turn(angle)
      end
      alias_method :rt, :right

      def left(angle)
        turn(-angle)
      end
      alias_method :lt, :left

      def forward(dist)
        x1 = x
        y1 = y
        x2 = x + dist * Math.sin(rad)
        y2 = y - dist * Math.cos(rad)

        @x = x2
        @y = y2

        Line.new(x1: x1, y1: y1, x2: x2, y2: y2, color: pen_color, width: pen_size) unless pen_up?
      end
      alias_method :fd, :forward

      def circle(radius, arc = 360)
        circle = Circle.apply(self, radius, arc)
        circle unless pen_up?
      end
      alias_method :ci, :circle

      def goto(x, y)
        x1 = @x
        y1 = @y

        @x = x
        @y = y

        Line.new(x1: x1, y1: y1, x2: x, y2: y, color: pen_color, width: pen_size) unless pen_up?
      end

      def face(dir)
        @direction = dir
        dispose_rotated_image
      end

      def turn(a)
        @direction = (direction + a) % 360
        dispose_rotated_image
      end

    end
  end
end