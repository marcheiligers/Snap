class Snap
  class Sprite
    attr_reader :orig_image, :orig_data, :orig_width, :orig_height
    attr_reader :image, :display, :name, :lock
    attr_accessor :x, :y, :r, :z, :visible

    alias_method :visible?, :visible

    def initialize(display, name, x: 0, y: 0, r: 0, z: 100)
      @display = display.swt_display
      @name = name

      @orig_data = Gfx.ImageData.new(path_from_default)
      @orig_image = Gfx.Image.new(@display, @orig_data)
      @orig_width = @orig_data.width
      @orig_height = @orig_data.height

      @x = x
      @y = y
      @r = r
      @z = z

      @visible = true

      @lock = Mutex.new
    end

    def goto(x, y)
      @x = x
      @y = y
    end

    def face(dir)
      @r = dir
      dispose_rotated_image
    end

    def turn(a)
      @r = (r + a) % 360
      dispose_rotated_image
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

    private

    def zoomed_dimensions
      w = h = 0
      if orig_width > orig_height
        w = orig_width * z.to_f / 100.0
        h = orig_height.to_f / orig_width * w
      else
        h = orig_height * z.to_f / 100.0
        w = orig_width.to_f / orig_height * h
      end

      [w, h]
    end

    def rotated_dimensions(w, h)
      w1 = h1 = 0
      r1 = r % 180

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
          # gc.draw_rectangle(0, 0, orig_width, orig_height)
          # gc.draw_rectangle(1, 1, orig_width - 1, orig_height - 1)
          # gc.draw_rectangle(2, 2, orig_width - 2, orig_height - 2)
        end

        result
      rescue => e
        puts e.full_message
      ensure
        gc.dispose if gc
      end
    end

    def make_tranparent_image_data(w, h)
      Gfx.ImageData.new(w, h, 32, orig_data.palette).tap do |image_data|
        w.times { |x| h.times { |y| image_data.set_alpha(x, y, 0) } }
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

      transform.scale(z / 100.0, z / 100.0)
      transform.rotate(r)
      transform.translate(-orig_width / 2, -orig_height / 2)

      gc.set_transform(transform)
      yield
    rescue => e
      puts e.full_message
    ensure
      transform.dispose
    end

    def rad(r = @r)
      (r / 360.0) * (Math::PI * 2)
    end

    def cos(r = @r)
      Math::cos(rad(r))
    end

    def sin(r = @r)
      Math::sin(rad(r))
    end
  end
end