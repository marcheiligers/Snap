require_relative 'font'

class Snap
  module Font
    def find_font(device, name)
      font_name = device.get_font_list(nil, true).map(&:name).include?(name) ? name : 'serif'
    end
  end
end
