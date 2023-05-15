import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        [this.action, this.targetViewId] = this.element.getAttribute("data-kanban-action").split(":")
        this.subjectType = this.element.getAttribute("data-subject-type")
        this.subjectViewId = this.element.getAttribute("data-subject-id")

        switch(this.action) {
            case "move-before":
                this.moveBefore();
                break;
        }

        this.element.remove();
    }

    moveBefore() {
        let subjectView = document.getElementById(this.subjectViewId)
        let targetView = document.getElementById(this.targetViewId)
        if (subjectView && targetView) {
            targetView.before(subjectView)
        }
    }
}
