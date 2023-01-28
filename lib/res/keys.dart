abstract class TodoKeys {
  static String todoItemTile(String name) => 'Todo Item Tile - $name';
  static String todoItemTileCheckbox(String name) =>
      'Todo Item Tile Checkbox - $name';
  static String addTodoButton = 'Add Todo Button';
  static String totalTasks(int tasks) => 'Total Tasks - ${tasks.toString()}';
  static String completedTasks(int tasks) =>
      'Completed Tasks - ${tasks.toString()}';
  static String todosScreen = 'Todos Screen';
  static String progressIndicator = 'Progress Indicator';
  static String todoItemList = 'Todo Item List';
  static String sortByDropdown = 'Sort By Dropdown';
  static String sortByDropdownMenuItem(String sortBy) =>
      'Sort By Dropdown Menu Item - $sortBy';

  //Add Edit Screen
  static String editScreen = 'Edit Screen';
  static String addScreen = 'Add Screen';
  static String saveButton = 'Save Button';

  static String nameTextField = 'Name TextField';

  static String priorityDropdownField = 'Priority Dropdown Field';
  static String priorityDropdownMenuItem(String priority) =>
      'Priority Dropdown Menu Item - $priority';

  static String confirmButton = 'Confirm Button';
  static String cancelButton = 'Cancel Button';
}
