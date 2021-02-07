class Snap
  class Menu
    include Publisher

    attr_reader :parent

    def initialize(parent)
      menu_bar = Swt::Widgets::Menu.new(parent, Swt::SWT::BAR)

      # TODO: Add Exit and About for Windows

      file_menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      file_menu_header.text = '&File'

      file_menu = Swt::Widgets::Menu.new(parent, Swt::SWT::DROP_DOWN)
      file_menu_header.menu = file_menu

      file_open_item = Swt::Widgets::MenuItem.new(file_menu, Swt::SWT::PUSH)
      file_open_item.text = "&Open...\t⌘O"
      file_open_item.accelerator = (Swt::SWT::MOD1 + 'O'.ord)
      file_open_item.add_selection_listener { publish(:open) }

      file_save_item = Swt::Widgets::MenuItem.new(file_menu, Swt::SWT::PUSH)
      file_save_item.text = "&Save\t⌘S"
      file_save_item.accelerator = (Swt::SWT::MOD1 + 'S'.ord)
      file_save_item.add_selection_listener { publish(:save) }

      file_save_as_item = Swt::Widgets::MenuItem.new(file_menu, Swt::SWT::PUSH)
      file_save_as_item.text = "Save &As...\t⇧⌘S"
      file_save_item.accelerator = (Swt::SWT::SHIFT | Swt::SWT::MOD1 | 'S'.ord)
      file_save_as_item.add_selection_listener { publish(:save_as) }

      edit_menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      edit_menu_header.text = '&Edit'

      edit_menu = Swt::Widgets::Menu.new(parent, Swt::SWT::DROP_DOWN)
      edit_menu_header.menu = edit_menu

      edit_cut_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_cut_item.text = "&Cut...\t⌘X"
      edit_cut_item.accelerator = (Swt::SWT::MOD1 + 'X'.ord)
      edit_cut_item.add_selection_listener { publish(:cut) }

      edit_copy_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_copy_item.text = "&Copy...\t⌘C"
      edit_copy_item.accelerator = (Swt::SWT::MOD1 + 'C'.ord)
      edit_copy_item.add_selection_listener { publish(:copy) }

      edit_paste_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_paste_item.text = "&Paste...\t⌘V"
      edit_paste_item.accelerator = (Swt::SWT::MOD1 + 'V'.ord)
      edit_paste_item.add_selection_listener { publish(:paste) }

      Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::SEPARATOR)

      edit_select_all_item = Swt::Widgets::MenuItem.new(edit_menu, Swt::SWT::PUSH)
      edit_select_all_item.text = "&Select All...\t⌘A"
      edit_select_all_item.accelerator = (Swt::SWT::MOD1 + 'A'.ord)
      edit_select_all_item.add_selection_listener { publish(:select_all) }

      code_menu_header = Swt::Widgets::MenuItem.new(menu_bar, Swt::SWT::CASCADE)
      code_menu_header.text = '&Code'

      code_menu = Swt::Widgets::Menu.new(parent, Swt::SWT::DROP_DOWN)
      code_menu_header.menu = code_menu

      code_run_item = Swt::Widgets::MenuItem.new(code_menu, Swt::SWT::PUSH)
      code_run_item.text = "&Run All\t⇧⌘↵"
      code_run_item.accelerator = (Swt::SWT::SHIFT | Swt::SWT::MOD1 | Swt::SWT::CR)
      code_run_item.add_selection_listener { publish(:run) }

      code_run_item = Swt::Widgets::MenuItem.new(code_menu, Swt::SWT::PUSH)
      code_run_item.text = "&Run Selection\t⌘↵"
      code_run_item.accelerator = (Swt::SWT::MOD1 | Swt::SWT::CR)
      code_run_item.add_selection_listener { publish(:run_selection) }

      parent.menu_bar = menu_bar
    end
  end
end