$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'bundler/setup'
Bundler.require(:default)
require_relative 'views/snap/app'
require_relative 'models/config'

class Snap
  Gfx = org.eclipse.swt.graphics

  APP_ROOT = File.expand_path('../..', __FILE__)
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))

  def start
    Swt::Widgets::Display.app_name = 'Snap'
    Swt::Widgets::Display.app_version = VERSION

    app = App.new

    # until the window (the Shell) has been closed
    while !app.shell.disposed?
      # check for and dispatch new gui events
      app.display.sleep unless app.display.read_and_dispatch
    end

    app.display.dispose if app.display
  end
end

Snap.new.start
