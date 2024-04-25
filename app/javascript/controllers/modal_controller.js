import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
    connect() {
        enter(this.element)
    }

    close() {
        leave(this.element).then(() => {
            this.element.remove()
        })
    }

    handleKeyup(event) {
        if (event.code == "Escape") {
            this.close()
        }
    }
}