require 'singleton'

class Snap
  Theme = Struct.new(:background, :sash_color)

  class Config
    include Singleton

    def theme
      @theme ||= Theme.new(Gfx.Color.new(display, 75, 75, 75), Gfx.Color.new(display, 64, 64, 64))
    end
  end
end