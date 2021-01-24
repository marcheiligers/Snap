require_relative 'stage'

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
    end

    ## Use after_body block to setup observers for widgets in body
    #
    # after_body {
    #
    # }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body do
      shell do
        # Replace example content below with custom shell content
        minimum_size 640, 480
        image File.join(APP_ROOT, 'package', 'windows', "Snap.ico") if OS.windows?
        text "Snap"

        sash_form do
          layout_data(:fill, :fill, true, true) # { height_hint 200 }
          sash_width 10
          # orientation :horizontal
          weights 1, 2

          # grid_layout(2, false)
          # layout_data :fill, :fill, true, true

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

          button do
            text 'Run'

            on_widget_selected do
              # puts "Run! #{@stage} #{editor} #{editor.text}"
              @stage.turtle.run(editor.text)
              @stage.paint
            end
          end

          button do
            text 'Stop'

            on_widget_selected do
              @stage.turtle.stop
              @stage.paint
            end
          end

          button do
            text 'Reset'

            on_widget_selected do
              @stage.reset
              @stage.paint
            end
          end
        end

        editor
      end
    end

    def init_stage
      stage
    end

    def init_menu
      menu_bar do
        menu do
          text '&File'
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
  end
end
