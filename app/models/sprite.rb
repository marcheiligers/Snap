class Sprite
  # TODO: draw sprites centered

  attr_reader :image, :display, :name
  attr_accessor :x, :y, :r, :z

  Gfx = org.eclipse.swt.graphics

  def initialize(display, name, x: 0, y: 0, r: 0, z: 100)
    @display = display.swt_display
    @name = name

    @x = x
    @y = y
    @r = r
    @z = z
  end

  def goto(x, y)
    @x = x
    @y = y
  end

  def turn(a)
    @r = (r + a) % 360
  end

  def path_from_default
    File.expand_path("../../images/#{name}.png", __dir__)
  end

  def image
    @image ||= Gfx.Image.new(display, path_from_default)
  end

  def image_data
    @data ||= image.get_image_data
  end

  def width
    image_data.width
  end

  def height
    image_data.height
  end

  def draw(stage, gc)
    gc.advanced = true
    puts 'Advanced graphics not supported' and return unless gc.advanced?

    w = h = 0
    if width > height
      w = m = width * z.to_f / 100.0
      h = height.to_f / width * m
    else
      h = m = height * z.to_f / 100.0
      w = width.to_f / height * m
    end

    transformed(gc, stage.zoom, w, h) do
      gc.draw_image(image, 0, 0, width, height, x, y, w.round, h.round)
    end
  end

  private

  def transformed(gc, zoom, w, h)
    old_transform = Gfx.Transform.new(gc.device)
    gc.get_transform(old_transform)

    transform = Gfx.Transform.new(gc.display)
    transform.scale(zoom, zoom)
    transform.translate(x + w / 2, y + h / 2)
    transform.rotate(r)
    transform.translate(-x - w / 2, -y - h / 2)

    gc.set_transform(transform)
    yield
  ensure
    gc.set_transform(old_transform)
    transform.dispose
  end
end
