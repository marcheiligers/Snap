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
        wait(0.01)
      end
      alias_method :rt, :right

      def left(angle)
        turn(-angle)
        wait(0.01)
      end
      alias_method :lt, :left

      def forward(dist)
        x1 = x + dist * Math.sin(rad)
        y1 = y - dist * Math.cos(rad)
        stage.add(Line.new(x1: x, y1: y, x2: x1, y2: y1, color: pen_color, width: pen_size)) unless pen_up?
        goto x1, y1
        wait(0.01)
      end
      alias_method :fd, :forward

      def circle(radius, arc = 360)
        Circle.apply(stage, self, radius, arc) unless pen_up?
        wait(0.01)
      end
      alias_method :ci, :circle

      def goto(x, y)
        @x = x
        @y = y
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