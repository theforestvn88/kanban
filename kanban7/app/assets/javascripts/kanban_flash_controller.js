import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "flash" ]

    connect() {
        this.closeFlash = setTimeout(() => {
            this.close()
        }, 5000)
    }

    disconnect() {
        clearTimeout(this.closeFlash)
    }

    close() {
        this.flashTarget.parentElement.removeAttribute("src")
        this.flashTarget.remove()
    }

    handleKeyup(e) {
        if (e.code == "Escape") {
            this.close();
        }
    }
}
