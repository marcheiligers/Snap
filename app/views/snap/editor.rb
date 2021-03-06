require 'forwardable'

class Snap
  class Editor
    extend Forwardable
    include Publisher
    using Preferences::Refinements

    attr_reader :editor, :parent

    def_delegator :@editor, :text, :code
    def_delegator :@editor, :text=, :code=
    def_delegators :@editor, :cut, :copy, :paste, :selection, :set_selection

    def initialize(parent, text)
      @parent = parent
      @editor = init_editor
      self.code = text
    end

    def selected_code
      sel = selection
      start = sel.x
      fin = sel.y

      while code[start -  1] != "\n" && start > 0 do
        start -= 1
      end
      while code[fin] != "\n" && fin < code.length do
        fin += 1
      end

      code[start...fin]
    end

    def init_editor
      font_name = parent.display.get_font_list(nil, true).map(&:name).include?('Consolas') ? 'Consolas' : 'Courier'
      editor = nil

      composite = Swt::Widgets::Composite.new(parent, 0)
      composite.layout = Swt::Layout::GridLayout.new
      composite.background = Preferences.theme.background.as_color

      # TODO: Syntax highlighting
      # See: http://www.java2s.com/Code/Java/SWT-JFace-Eclipse/JavaSourcecodeViewer.htm
      # And: https://github.com/rouge-ruby/rouge

      editor = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER | Swt::SWT::MULTI | Swt::SWT::V_SCROLL | Swt::SWT::H_SCROLL)
      editor.layout_data = Swt::Layout::GridData.new(Swt::SWT::FILL, Swt::SWT::FILL, true, true)
      editor.font = Gfx.Font.new(display, font_name, 15, Swt::SWT::NORMAL)

      button_composite = Swt::Widgets::Composite.new(composite, 0)
      button_composite.layout = Swt::Layout::RowLayout.new
      button_composite.background = Preferences.theme.background.as_color

      # TODO: add button images

      run_button = Swt::Widgets::Button.new(button_composite, Swt::SWT::FLAT)
      run_button.text = 'Run'
      run_button.add_selection_listener { publish(:run) }

      stop_button = Swt::Widgets::Button.new(button_composite, Swt::SWT::FLAT)
      stop_button.text = 'Stop'
      stop_button.add_selection_listener { publish(:stop) }

      reset_button = Swt::Widgets::Button.new(button_composite, Swt::SWT::FLAT)
      reset_button.text = 'Reset'
      reset_button.add_selection_listener { publish(:reset) }

      editor
    end
  end
end
