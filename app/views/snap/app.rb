require_relative 'stage'
require_relative '../../models/project'

class Snap
  class App
    attr_reader :shell, :sash_form, :stage, :editor, :temp_project, :project

    def initialize
      @temp_project = Project.new
      @project = nil

      # A Shell is a window in SWT parlance.
      @shell = Swt::Widgets::Shell.new

      # Set the window title bar text
      shell.text = 'Snap'
      shell.set_size(640, 480)
      shell.set_minimum_size(320, 240)
      # image File.join(APP_ROOT, 'package', 'windows', 'Snap.ico') if OS.windows?

      shell.layout = Swt::Layout::FillLayout.new
      @sash_form = Swt::Custom::SashForm.new(shell, Swt::SWT::HORIZONTAL)
      # sash_width 10
      # weights 1, 2

      @editor = init_editor
      editor.text = temp_project.code

      @stage = Stage.new(sash_form)

      init_menu

      @shell.open
    end

    def display
      Swt::Widgets::Display.current
    end

    def init_editor
      font_name = display.get_font_list(nil, true).map(&:name).include?('Consolas') ? 'Consolas' : 'Courier'
      editor = nil

      composite = Swt::Widgets::Composite.new(sash_form, 0)
      composite.layout = Swt::Layout::GridLayout.new

      # TODO: Syntax highlighting
      # See: http://www.java2s.com/Code/Java/SWT-JFace-Eclipse/JavaSourcecodeViewer.htm
      # And: https://github.com/rouge-ruby/rouge

      editor = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER | Swt::SWT::MULTI | Swt::SWT::V_SCROLL | Swt::SWT::H_SCROLL)
      editor.layout_data = Swt::Layout::GridData.new(Swt::SWT::FILL, Swt::SWT::FILL, true, true)
      editor.font = Gfx.Font.new(display, font_name, 15, Swt::SWT::NORMAL)

      button_composite = Swt::Widgets::Composite.new(composite, 0)
      button_composite.layout = Swt::Layout::RowLayout.new

      # TODO: add button images

      run_button = Swt::Widgets::Button.new(button_composite, Swt::SWT::FLAT)
      run_button.text = 'Run'
      run_button.add_selection_listener { do_run }

      stop_button = Swt::Widgets::Button.new(button_composite, Swt::SWT::FLAT)
      stop_button.text = 'Stop'
      stop_button.add_selection_listener do
        stage.turtle.stop
        stage.paint
      end

      reset_button = Swt::Widgets::Button.new(button_composite, Swt::SWT::FLAT)
      reset_button.text = 'Reset'
      reset_button.add_selection_listener do
        stage.reset
        stage.paint
      end

      editor
    end

    def init_stage
      stage
    end

    def init_menu
      menu_bar = Swt::Widgets::Menu.new(shell, Swt::SWT::BAR)

      # TODO: Add Exit and About for Windows

      file_menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      file_menu_header.text = '&File'

      file_menu = Swt::Widgets::Menu.new(shell, Swt::SWT::DROP_DOWN)
      file_menu_header.menu = file_menu

      file_open_item = Swt::Widgets::MenuItem.new(file_menu, Swt::SWT::PUSH)
      file_open_item.text = "&Open...\t⌘O"
      file_open_item.accelerator = (Swt::SWT::MOD1 + 'O'.ord)
      file_open_item.add_selection_listener { do_open }

      file_save_item = Swt::Widgets::MenuItem.new(file_menu, Swt::SWT::PUSH)
      file_save_item.text = "&Save\t⌘S"
      file_save_item.accelerator = (Swt::SWT::MOD1 + 'S'.ord)
      file_save_item.add_selection_listener { do_save }

      file_save_as_item = Swt::Widgets::MenuItem.new(file_menu, Swt::SWT::PUSH)
      file_save_as_item.text = "Save &As...\t⇧⌘S"
      file_save_item.accelerator = (Swt::SWT::SHIFT | Swt::SWT::MOD1 | 'S'.ord)
      file_save_as_item.add_selection_listener { do_save_as }

      edit_menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      edit_menu_header.text = '&Edit'

      edit_menu = Swt::Widgets::Menu.new(shell, Swt::SWT::DROP_DOWN)
      edit_menu_header.menu = edit_menu

      edit_cut_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_cut_item.text = "&Cut...\t⌘X"
      edit_cut_item.accelerator = (Swt::SWT::MOD1 + 'X'.ord)
      edit_cut_item.add_selection_listener { editor.cut }

      edit_copy_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_copy_item.text = "&Copy...\t⌘C"
      edit_copy_item.accelerator = (Swt::SWT::MOD1 + 'C'.ord)
      edit_copy_item.add_selection_listener { editor.copy }

      edit_paste_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_paste_item.text = "&Paste...\t⌘V"
      edit_paste_item.accelerator = (Swt::SWT::MOD1 + 'V'.ord)
      edit_paste_item.add_selection_listener { editor.paste }

      Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::SEPARATOR)

      edit_select_all_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_select_all_item.text = "&Select All...\t⌘A"
      edit_select_all_item.accelerator = (Swt::SWT::MOD1 + 'A'.ord)
      edit_select_all_item.add_selection_listener { editor.set_selection 0, editor.text.length }

      code_menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      code_menu_header.text = '&Code'

      code_menu = Swt::Widgets::Menu.new(shell, Swt::SWT::DROP_DOWN)
      code_menu_header.menu = code_menu

      code_run_item = Swt::Widgets::MenuItem.new(code_menu, Swt::SWT::PUSH)
      code_run_item.text = "&Run All\t⇧⌘↵"
      code_run_item.accelerator = (Swt::SWT::SHIFT | Swt::SWT::MOD1 | Swt::SWT::CR)
      code_run_item.add_selection_listener { do_run }

      code_run_item = Swt::Widgets::MenuItem.new(code_menu, Swt::SWT::PUSH)
      code_run_item.text = "&Run Selection\t⌘↵"
      code_run_item.accelerator = (Swt::SWT::MOD1 | Swt::SWT::CR)
      code_run_item.add_selection_listener { do_run_selection }

      shell.menu_bar = menu_bar
    end

    def do_open
      # TODO: Ask about current project save

      filepath = get_filepath(Swt::SWT::OPEN)
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
      filepath = get_filepath(Swt::SWT::SAVE)

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

    def do_run
      code = editor.text

      temp_project.code = code
      temp_project.save

      stage.turtle.run(code)
      stage.paint
    end

    def do_run_selection
      code = editor.text
      sel = editor.selection
      start = sel.x
      fin = sel.y

      while code[start -  1] != "\n" && start > 0 do
        start -= 1
      end
      while code[fin] != "\n" && fin < code.length do
        fin += 1
      end

      temp_project.code = code
      temp_project.save

      puts code[start...fin]

      stage.turtle.run(code[start...fin])
      stage.paint
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
