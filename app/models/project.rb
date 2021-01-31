require 'rubygems/package'
require 'zlib'
require 'yaml'

class Project
  CURRENT_VERSION = 1
  EXTENSION = '.snapproject'

  UnrecognizedVersion = Class.new(StandardError)

  attr_reader :filepath
  attr_accessor :code

  def initialize(filepath = nil)
    @code = ''
    @filepath = normalize_filepath(filepath) || File.join(Dir.pwd, EXTENSION)
    load if File.exist?(@filepath)
  end

  def load
    tar = Gem::Package::TarReader.new(Zlib::GzipReader.open(filepath))
    tar.rewind
    tar.each do |file|
      if file.full_name == 'index.yaml'
        content = YAML.load(file.read)
        raise UnrecognizedVersion, "Unrecognized project version #{content[:version]}" unless content[:version] == 1
        @code = content[:code]
      end
    end
  ensure
    tar.close
  end

  def save
    File.open(filepath, 'wb') do |file|
      Zlib::GzipWriter.wrap(file) do |gzip|
        Gem::Package::TarWriter.new(gzip) do |tar|
          add_file(tar, 'index.yaml', index_content)
        end
      end
    end
  end

  def add_file(tar, filename, content)
    tar.add_file_simple(filename, 0644, content.length) do |io|
      io.write(content)
    end
  end

  def index_content
    {
      version: CURRENT_VERSION,
      code: code
    }.to_yaml
  end

  def normalize_filepath(filepath)
    return filepath if filepath&.end_with?(EXTENSION)

    "#{filepath}#{EXTENSION}"
  end
end
