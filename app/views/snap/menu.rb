class Snap
  class Menu
    include Publisher

    attr_reader :parent, :menu_bar

    def initialize(parent)
      @parent = parent
      @menu_bar = Swt::Widgets::Menu.new(parent, Swt::SWT::BAR)

      file_menu = add_menu('&File')
      file_open_item = add_menu_item(file_menu, "&Open...\t⌘O", Swt::SWT::MOD1 + 'O'.ord, :open)
      file_save_item = add_menu_item(file_menu, "&Save\t⌘S", Swt::SWT::MOD1 + 'S'.ord, :save)
      file_save_as_item = add_menu_item(file_menu, "Save &As...\t⇧⌘S", Swt::SWT::SHIFT | Swt::SWT::MOD1 | 'S'.ord, :save_as)
      file_exit = add_menu_item(file_menu, "E&xit", nil, :quit, Swt::SWT::ID_QUIT)

      edit_menu = add_menu('&Edit')
      edit_cut_item = add_menu_item(edit_menu, "&Cut...\t⌘X", Swt::SWT::MOD1 + 'X'.ord, :cut)
      edit_copy_item = add_menu_item(edit_menu, "&Copy...\t⌘C", Swt::SWT::MOD1 + 'C'.ord, :copy)
      edit_paste_item = add_menu_item(edit_menu, "&Paste...\t⌘V", Swt::SWT::MOD1 + 'V'.ord, :paste)
      add_separator(edit_menu)
      edit_select_all_item = add_menu_item(edit_menu, "&Select All...\t⌘A", Swt::SWT::MOD1 + 'A'.ord, :select_all)

      code_menu = add_menu('&Code')
      code_run_item = add_menu_item(code_menu, "&Run All\t⇧⌘↵", Swt::SWT::SHIFT | Swt::SWT::MOD1 | Swt::SWT::CR, :run)
      code_run_item = add_menu_item(code_menu, "&Run Selection\t⌘↵", Swt::SWT::MOD1 | Swt::SWT::CR, :run_selection)

      help_menu = add_menu('&Help')
      documentation_item = add_menu_item(help_menu, "&Documentation\tF1", Swt::SWT::F1, :help)
      about_item = add_menu_item(help_menu, "&About", nil, :about, Swt::SWT::ID_ABOUT)

      parent.menu_bar = menu_bar
    end

    # https://stackoverflow.com/questions/32409679/capture-about-preferences-and-quit-menu-items
    # SWT.ID_PREFERENCES, SWT.ID_ABOUT and SWT.ID_QUIT
    def add_menu_item(menu, text, accel, event, id = nil)
      menu_item = system_menu.items.detect { |item| item.id == id } if OS.mac? && !id.nil?

      unless menu_item
        menu_item = Swt::Widgets::MenuItem.new(menu, Swt::SWT::PUSH)
        menu_item.text = text
        menu_item.accelerator = accel unless accel.nil?
      end

      menu_item.tap { |m| m.add_selection_listener { publish(event) } }
    end

    def add_menu(text)
      menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      menu_header.text = text

      menu = Swt::Widgets::Menu.new(parent, Swt::SWT::DROP_DOWN)

      menu_header.menu = menu
    end

    def add_separator(menu)
      Swt::Widgets::MenuItem.new(menu, Swt::SWT::SEPARATOR)
    end

    def system_menu
      @system_menu ||= parent.display.system_menu
    end
  end
end