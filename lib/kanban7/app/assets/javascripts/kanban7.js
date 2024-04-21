import KanbanBoardController from "./kanban_board_controller"
import KanbanListController from "./kanban_list_controller"
import KanbanCardController from "./kanban_card_controller"
import KanbanModalController from "./kanban_modal_controller"
import KanbanFlashController from "./kanban_flash_controller"
import KanbanActionController from "./kanban_action_controller"

window.Stimulus.register("kanban-board", KanbanBoardController)
window.Stimulus.register("kanban-list", KanbanListController)
window.Stimulus.register("kanban-card", KanbanCardController)
window.Stimulus.register("kanban-modal", KanbanModalController)
window.Stimulus.register("kanban-flash", KanbanFlashController)
window.Stimulus.register("kanban-action", KanbanActionController)