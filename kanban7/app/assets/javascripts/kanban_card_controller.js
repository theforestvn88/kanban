import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "options" ]
    
    connect() {}

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
