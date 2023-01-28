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
}
