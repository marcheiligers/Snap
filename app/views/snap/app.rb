require_relative '../concerns/publisher'
require_relative 'menu'
require_relative 'editor'
require_relative 'stage'
require_relative 'string_dialog'
require_relative '../../models/project'
require_relative '../../models/executor'

class Snap
  class App
    using Preferences::Refinements

    attr_reader :shell, :sash_form, :stage, :editor, :temp_project, :project, :executor

    def initialize
      @temp_project = Project.new
      @project = nil

      # A Shell is a window in SWT parlance.
      @shell = Swt::Widgets::Shell.new

      # Set the window title bar text
      shell.text = 'Snap'
      shell.set_minimum_size(320, 240)
      shell.background = Preferences.theme.background.as_color
      # image File.join(APP_ROOT, 'package', 'windows', 'Snap.ico') if OS.windows?

      shell.layout = Swt::Layout::FillLayout.new
      @sash_form = Swt::Custom::SashForm.new(shell, Swt::SWT::HORIZONTAL)
      @sash_form.sash_width = 8
      @sash_form.background = Preferences.theme.sash.as_color

      @menu = Menu.new(shell)
      @menu.subscribe(self)
      @editor = Editor.new(sash_form, temp_project.code)
      @editor.subscribe(self)
      @stage = Stage.new(sash_form)

      shell.pack
      shell.set_size(640, 480)
      shell.open
    end

    def display
      Swt::Widgets::Display.current
    end

    # Event handlers
    def on_open
      # TODO: Ask about current project save

      filepath = get_filepath(Swt::SWT::OPEN)
      @project = Project.new(filepath)
      @editor.code = @project.code
    rescue => e
      puts e.full_message
    end

    def on_save
      return on_save_as if @project.nil?

      @project.code = @editor.code
      @project.save
    end

    def on_save_as
      filepath = get_filepath(Swt::SWT::SAVE)

      # TODO: ask about overwrite

      if @project
        @project.filepath = filepath
      else
        @project = Project.new(filepath)
      end
      @project.code = @editor.code
      @project.save
    rescue => e
      puts e.full_message
    end

    def on_quit
      Preferences.save
      shell.dispose
    end

    def on_run
      save_temp
      run_code(editor.code)
    end

    def on_run_selection
      save_temp
      run_code(editor.selected_code)
    end

    def save_temp
      temp_project.code = editor.code
      temp_project.save
    end

    def run_code(code)
      return if executor && executor.running?

      @executor = Executor.new(stage)
      executor.exec(code)
    end

    def on_stop
      executor.stop if executor
    end

    def on_reset
      stage.reset
      stage.paint
    end

    def on_cut
      editor.cut
    end

    def on_copy
      editor.copy
    end

    def on_paste
      editor.paste
    end

    def on_select_all
      editor.set_selection 0, editor.code.length
    end

    def get_filepath(type)
      dialog = Swt::Widgets::FileDialog.new(shell, type)
      dialog.filter_extensions = %w[*.* *.snapproject]
      dialog.filter_names = ['All Files', 'Snap Projects']
      dialog.filter_index = 1
      dialog.open
    end
  end
end
