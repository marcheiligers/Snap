require_relative 'stage'
require_relative '../../models/project'

class Snap
  class AppView
    include Glimmer::UI::CustomShell

    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    # option :greeting, default: 'Hello, World!'

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body do
      Display.setAppName('Snap')
      Display.setAppVersion(VERSION)

      @display = display do
        on_about { display_about_dialog }
        on_preferences { display_preferences_dialog }
      end

      @temp_project = Project.new
      @project = nil
    end

    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
      @editor.text = @temp_project.code
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body do
      shell do
        # Replace example content below with custom shell content
        size 640, 480
        minimum_size 320, 240
        image File.join(APP_ROOT, 'package', 'windows', 'Snap.ico') if OS.windows?
        text "Snap"

        sash_form do
          layout_data(:fill, :fill, true, true) # { height_hint 200 }
          sash_width 10
          weights 1, 2

          @editor = init_editor
          @stage = init_stage
        end
        init_menu
      end
    end

    def init_editor
      font_name = display.get_font_list(nil, true).map(&:name).include?('Consolas') ? 'Consolas' : 'Courier'
      editor = nil

      composite do
        layout_data(:fill, :fill, true, true)
        grid_layout 1, true

        editor = code_text do
          layout_data :fill, :fill, true, true
          font name: font_name, height: OS.mac? ? 15 : 12
          foreground rgb(75, 75, 75)
          focus true
          top_margin 5
          right_margin 5
          bottom_margin 5
          left_margin 5
        end

        composite do
          row_layout

          button(:flat) do
            image File.join(APP_ROOT, 'images', 'play.png')

            on_widget_selected do
              code = editor.text

              @temp_project.code = code
              @temp_project.save

              @stage.turtle.run(code)
              @stage.paint
            end
          end

          button(:flat) do
            image File.join(APP_ROOT, 'images', 'stop.png')

            on_widget_selected do
              @stage.turtle.stop
              @stage.paint
            end
          end

          button(:flat) do |btn|
            image File.join(APP_ROOT, 'images', 'reset.png')

            on_widget_selected do
              @stage.reset
              @stage.paint
            end
          end
        end
      end

      editor
    end

    def init_stage
      stage
    end

    def init_menu
      menu_bar do
        menu do
          text '&File'
          menu_item do
            text '&Open...'
            on_widget_selected { do_open }
          end
          menu_item do
            text '&Save...'
            on_widget_selected { do_save }
          end
          menu_item do
            text 'Save &As...'
            on_widget_selected { do_save_as }
          end
          menu_item do
            text '&About...'
            on_widget_selected { display_about_dialog }
          end
          menu_item do
            text '&Preferences...'
            on_widget_selected { display_preferences_dialog }
          end
        end
      end
    end

    def display_about_dialog
      message_box(body_root) do
        text 'About'
        message "Snap #{VERSION}\n\n#{LICENSE}"
      end.open
    end

    def display_preferences_dialog
      dialog(swt_widget) {
        text 'Preferences'
        grid_layout {
          margin_height 5
          margin_width 5
        }
        group {
          row_layout {
            type :vertical
            spacing 10
          }
          text 'Greeting'
          font style: :bold
          [
            'Hello, World!',
            'Howdy, Partner!'
          ].each do |greeting_text|
            button(:radio) {
              text greeting_text
              selection bind(self, :greeting) { |g| g == greeting_text }
              layout_data {
                width 160
              }
              on_widget_selected { |event|
                self.greeting = event.widget.getText
              }
            }
          end
        }
      }.open
    end

    def do_open
      # TODO: Ask about current project save

      filepath = get_filepath(:open)
      @project = Project.new(filepath)
      @editor.text = @project.code

      puts @project.inspect
    rescue => e
      puts e.full_message
    end

    def do_save
      return do_save_as if @project.nil?

      @project.code = @editor.text
      @project.save
    end

    def do_save_as
      filepath = get_filepath(:save)

      # TODO: ask about overwrite

      if @project
        @project.filepath = filepath
      else
        @project = Project.new(filepath)
      end
      @project.code = @editor.text
      @project.save
    rescue => e
      puts e.full_message
    end

    def get_filepath(type)
      save_dialog = file_dialog(type)
      save_dialog.filter_extensions = %w[*.* *.snapproject]
      save_dialog.filter_names = ['All Files', 'Snap Projects']
      save_dialog.filter_index = 1
      save_dialog.open
    end
  end
end
