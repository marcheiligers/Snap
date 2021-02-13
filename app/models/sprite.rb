require_relative 'concerns/motion'
require_relative 'concerns/looks'
require_relative 'concerns/drawing'

class Snap
  class Sprite
    include Motion
    include Looks
    include Drawing
    # TODO: Add font and text rendering

    attr_reader :orig_image, :orig_data, :orig_width, :orig_height
    attr_reader :image, :display, :name, :lock

    def initialize(display, name, x: 0, y: 0, direction: 0, size: 100)
      @display = display
      @name = name

      @orig_data = Gfx.ImageData.new(path_from_default)
      @orig_image = Gfx.Image.new(@display, @orig_data)
      @orig_width = @orig_data.width
      @orig_height = @orig_data.height

      init_motion(x: x, y: y, direction: direction)
      init_drawing(size: 1, color: [0, 0, 0, 255], up: false)
      init_looks(size: size, visible: true)
      @size = size

      @visible = true

      @lock = Mutex.new
    end

    def path_from_default
      File.expand_path("../../images/#{name}.png", __dir__)
    end

    def draw(stage, gc)
      return unless visible?

      w, h = rotated_dimensions(*zoomed_dimensions)
      lock.synchronize do
        gc.draw_image(rotated_image(gc.device), 0, 0, w, h, x - w / 2, y - h / 2, w, h)
      end
    end

    def cos(direction = @direction)
      Math::cos(rad(direction))
    end

    def sin(direction = @direction)
      Math::sin(rad(direction))
    end

    private

    def zoomed_dimensions
      w = h = 0
      if orig_width > orig_height
        w = orig_width * size.to_f / 100.0
        h = orig_height.to_f / orig_width * w
      else
        h = orig_height * size.to_f / 100.0
        w = orig_width.to_f / orig_height * h
      end

      [w, h]
    end

    def rotated_dimensions(w, h)
      w1 = h1 = 0
      r1 = direction % 180

      if r1 < 90
        w1 = w * cos(r1) + h * sin(r1)
        h1 = w * sin(r1) + h * cos(r1)
      else
        w1 = h * cos(r1 - 90) + w * sin(r1 - 90)
        h1 = h * sin(r1 - 90) + w * cos(r1 - 90)
      end

      # weirdly, this makes no difference to the placement of the image
      #   but fixes an issue where the top part of the image is cut off when drawing transparently
      [w1.ceil * 2, h1.ceil * 2]
    end

    def rotated_image(device)
      @rotated_image ||= begin
        w1, h1 = rotated_dimensions(*zoomed_dimensions)
        transparent_image_data = make_tranparent_image_data(w1, h1)
        result = Gfx.Image.new(device, transparent_image_data)
        gc = Gfx.GC.new(result)
        gc.advanced = true

        rotation_transform(gc) do
          gc.draw_image(orig_image, 0, 0)
        end

        result
      rescue => e
        puts e.full_message
      ensure
        gc.dispose if gc
      end
    end

    def make_tranparent_image_data(w, h)
      img = Gfx.ImageData.new(w, h, 32, orig_data.palette).tap do |image_data|
        image_data.set_alphas(0, 0, w * h, Array.new(w * h, 0), 0)
      end
    end

    def dispose_rotated_image
      lock.synchronize do
        if @rotated_image
          @rotated_image.dispose
          @rotated_image = nil
        end
      end
    end

    def rotation_transform(gc)
      transform = Gfx.Transform.new(gc.display)

      w1, h1 = rotated_dimensions(*zoomed_dimensions)
      transform.translate(w1 / 2, h1 / 2)

      transform.scale(size / 100.0, size / 100.0)
      transform.rotate(direction)
      transform.translate(-orig_width / 2, -orig_height / 2)

      gc.set_transform(transform)
      yield
    rescue => e
      puts e.full_message
    ensure
      transform.dispose
    end

    def rad(direction = @direction)
      (direction / 360.0) * (Math::PI * 2)
    end
  end
end