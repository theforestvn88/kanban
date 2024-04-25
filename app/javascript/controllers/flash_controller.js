import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
    connect() {
        enter(this.element).then(() => {
            return new Promise(() => {
                setTimeout(() => {
                    this.close()
                }, 5000)
            })
        })
    }

    close() {
        leave(this.element).then(() => {
            this.element.remove()
        })
    }
}