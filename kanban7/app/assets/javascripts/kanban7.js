import KanbanBoardController from "./kanban_board_controller"
import KanbanListController from "./kanban_list_controller"
import KanbanCardController from "./kanban_card_controller"

window.Stimulus.register("kanban-board", KanbanBoardController)
window.Stimulus.register("kanban-list", KanbanListController)
window.Stimulus.register("kanban-card", KanbanCardController)