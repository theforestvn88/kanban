import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "options" ]

    connect() {
        console.log("List Controller connected !!!")
    }

    showOptions() {
        if (this.hasOptionsTarget) {
            this.optionsTarget.classList.remove("hidden")
        }
    }

    hideOptions() {
        if (this.hasOptionsTarget) {
            this.optionsTarget.classList.add("hidden")
        }
    }
}
