require_relative '../../models/sprite'
require_relative '../../models/turtle'
require_relative '../../models/line'

class Stage
  include Glimmer::UI::CustomWidget

  attr_reader :turtle

  SIZE = 1_000.0 # Stage is a 1,000px square

  attr_reader :turtle, :widget, :objects

  before_body do
    @turtle = Turtle.new(display, self)
    @objects = []
    add(Line.new(x1: 0, y1: 0, x2: 100, y2: 50))
  end

  body do
    @widget = canvas do
      layout_data :fill, :fill, true, true

      on_paint_control do |e|
        paint_background(e.gc)
        turtle.draw(self, e.gc)
        puts "Objects: #{objects.inspect}"
        objects.each { |o| o.draw(self, e.gc) }
      end
    end
  end

  def add(object)
    puts "Stage#add(#{object.inspect})"
    objects << object
  end

  def clear
    objects = []
  end

  def zoom
    rc = client_area
    (rc.width > rc.height ? rc.height : rc.width) / SIZE
  end

  def client_area
    widget.get_client_area
  end

  def paint_background(gc)
    rc = client_area

    gc.foreground = color(:dark_gray).swt_color
    gc.background = color(:white).swt_color

    gc.fill_rectangle(0, 0, rc.width, rc.height)
    gc.draw_rectangle(0, 0, rc.width - 1, rc.height - 1)
  end
end
