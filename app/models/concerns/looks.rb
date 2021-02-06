class Snap
  class Sprite
    module Looks
      attr_reader :size, :visible
      alias_method :visible?, :visible

      def init_looks(size: 100, visible: true)
        @size = size
        @visible = visible
      end

      def hide_turtle
        @visible = false
        redraw
      end
      alias_method :ht, :hide_turtle

      def show_turtle
        @visible = true
        redraw
      end
      alias_method :st, :show_turtle

      def change_size(size)
        @size = size
      end
    end
  end
end