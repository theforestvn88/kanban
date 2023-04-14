import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "addCardBtn", "formCard" ]

    connect() {
        console.log("List Controller connected !!!")
    }

    showCardForm() {
        this.addCardBtnTarget.classList.add("hidden")
        this.formCardTarget.classList.remove("hidden")
    }
}
