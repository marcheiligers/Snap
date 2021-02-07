class Snap
  class Drawable
    def draw(stage, gc)
      raise NotImplementedError, "#{self.class.name} must implement #draw(stage, gc)"
    end
  end
end
