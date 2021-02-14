class Snap
  class Circle < Oval
    def self.apply(sprite, radius, arc = 360)
      dx = sprite.sin(90 - sprite.direction) * radius
      dy = sprite.cos(90 - sprite.direction) * radius

      center_x = sprite.x + dx
      center_y = sprite.y + dy
      new_dir = sprite.direction + arc
      new_x = center_x - sprite.sin(90 - new_dir) * radius
      new_y = center_y - sprite.cos(90 - new_dir) * radius

      circle = new(
        x: sprite.x - (radius - dx),
        y: sprite.y - (radius - dy),
        w: radius * 2,
        h: radius * 2,
        start: sprite.direction,
        arc: arc,
        color: sprite.pen_color,
        width: sprite.pen_size
      )

      sprite.goto(new_x, new_y)
      sprite.face(new_dir)

      circle
    end
  end
end