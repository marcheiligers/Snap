class Snap
  class StringDialog < Swt::Widgets::Dialog
    attr_reader :shell, :text, :value

    include Swt::Widgets
    include Swt::Layout

    def initialize(actor, question, parent)
      super parent

      @actor = actor
      @question = question
    end

    def open
      @shell = Shell.new(parent, Swt::SWT::TITLE | Swt::SWT::BORDER | Swt::SWT::APPLICATION_MODAL)
      shell.text = "#{@actor.name} is asking..."

      shell.layout = GridLayout.new(2, true)

      label = Label.new(shell, Swt::SWT::NULL)
      label.text = @question

      @text = Text.new(shell, Swt::SWT::SINGLE | Swt::SWT::BORDER)
      text.text = ''
      text.add_modify_listener { |e| text_modified(e) }

      ok_button = Button.new(shell, Swt::SWT::PUSH);
      ok_button.text = 'Ok'
      ok_button.layout_data = GridData.new(GridData::HORIZONTAL_ALIGN_END)
      ok_button.add_selection_listener { |e| ok_click(e) }

      cancel_button = Button.new(shell, Swt::SWT::PUSH);
      cancel_button.text = 'Cancel'
      cancel_button.add_selection_listener { |e| cancel_click(e) }

      shell.pack
      shell.open

      while !shell.disposed?
        # check for and dispatch new gui events
        parent.display.sleep unless parent.display.read_and_dispatch
      end

      value
    end

    def text_modified(e)
      @value = text.text
    end

    def ok_click(e)
      shell.dispose
    end

    def cancel_click(e)
      shell.dispose
    end
  end
end