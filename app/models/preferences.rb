require 'yaml'
require 'json'

class Snap
  module Preferences
    EXTENSION = '.snapconfig'

    module Refinements
      refine Array do
        def as_color
          Gfx.Color.new(display, *self[0..4])
        end
      end
    end

    def self.method_missing(name, *args)
      Settings.send(name, *args)
    rescue => e
      puts e.full_message
    end

    def self.save
      File.open(path, 'w') { |f| f.puts YAML.dump(JSON.parse(Settings.to_json)) }
    end

    def self.load
      Config.setup do |config|
        # TODO: load default from JAR
        config.load_and_set_settings('package/default.snapconfig', '.snapconfig')
      end
    end

    def self.path
      File.join(Dir.pwd, EXTENSION)
    end
  end
end