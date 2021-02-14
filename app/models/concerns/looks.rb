class Snap
  class Sprite
    module Looks
      attr_accessor :size, :visible
      alias_method :visible?, :visible

      def init_looks(size: 100, visible: true)
        @size = size
        @visible = visible
      end

      def hide_turtle
        @visible = false
      end
      alias_method :ht, :hide_turtle

      def show_turtle
        @visible = true
      end
      alias_method :st, :show_turtle

      def set_size_to(size)
        @size = size
        dispose_rotated_image
      end
    end
  end
end