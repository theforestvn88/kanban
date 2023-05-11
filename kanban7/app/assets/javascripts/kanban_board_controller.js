import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ ]
    static values = { kanban: String, board: String, boardid: Number }

    connect() {
        this.root = document.documentElement;
    }

    // drag and drop

    dragStart(event) {
        const [dragObject, dragObjectId] = event.target.id.split("_")
        event.dataTransfer.setData("id", dragObjectId)
        event.dataTransfer.setData("type", dragObject)
        event.dataTransfer.effectAllowed = "move"

        this.#cloneDragItem(event.target, event.x, event.y)
        this.#blurCardItem(event.target)
        this.#disDroppableCardItem(event.target)
    }

    dragOver(event) {
        this.#moveDragItem(event.x, event.y)

        this.cloneDI.classList.add("hidden")
        let dropEl = this.#findDropObject(event)
        if (dropEl) {
            if (this.preDropOverElement) this.preDropOverElement.classList.remove(this.#paddingStyle())
            this.preDropOverElement = dropEl
            this.preDropOverElement.classList.add(this.#paddingStyle())
        }
        this.cloneDI.classList.remove("hidden")

        event.preventDefault()
        return false
    }

    dragLeave(event) {}

    dragEnter(event) {}

    drop(event) {
        const dragObjectType = event.dataTransfer.getData("type")
        const dragObjectId = event.dataTransfer.getData("id")

        this.cloneDI.classList.add("hidden")
        let dropTarget = this.#findDropObject(event)
        if (dropTarget) {
            if (this.preDropOverElement) this.preDropOverElement.classList.remove(this.#paddingStyle())
            const dropId = dropTarget.getAttribute("id")
            const currPos = parseFloat(dropTarget.getAttribute("data-currpos"))
            const prevPos = parseFloat(dropTarget.getAttribute("data-prevpos"))
            const parentKey = dropTarget.getAttribute("data-parentkey")
            const parentId = dropTarget.getAttribute("data-parentid")

            const dropBody = { }
            dropBody["user-action"] = "move"
            dropBody[`${dragObjectType}`] = {}
            if (parentId) dropBody[`${dragObjectType}`][`${parentKey}`] = `${parentId}`
            if (currPos) {
                dropBody[`${dragObjectType}`]["position"] = `${(currPos + prevPos)/2}`
            } else {
                dropBody["prev_position"] = `${prevPos}`
            }
            if (dropId) dropBody["next_view_id"] = `${dropId}`

            this.#sendDropApi(`/kanban7/${this.kanbanValue}/${this.boardValue}s/${this.boardidValue}/${dragObjectType}s/${dragObjectId}`, dropBody)
                .then(html => {
                    Turbo.renderStreamMessage(html)
                    this.cloneDI.remove()
                })
                .catch(error => {
                    error.then(html => {
                        console.log(html)
                        Turbo.renderStreamMessage(html)
                    })
                    
                    this.#revert(document.getElementById(`${dragObjectType}_${dragObjectId}`))
                })
        } else {
            this.#revert(document.getElementById(`${dragObjectType}_${dragObjectId}`))
        }

        event.preventDefault()
    }

    dragEnd(event) {}

    // private

    #cloneDragItem(dragItem, mouseX, mouseY) {
        var rect = dragItem.getBoundingClientRect();
        this.cloneDI = dragItem.cloneNode(true);
        this.cloneDI.setAttribute("droppable", "false")
        this.cloneDI.setAttribute("draggable", "false")
        this.cloneDI.style["width"] = rect.width + 'px';
        this.cloneDI.style["height"] = rect.height + 'px';
        this.cloneDI.style["top"] = rect.top + 'px';
        this.cloneDI.style["left"] = rect.left + 'px';
        this.cloneDI.classList.add("z-50", "fixed", "rotate-3", "pointer-events-none")

        this.cloneOffsetX = mouseX - rect.left;
        this.cloneOffsetY = mouseY - rect.top;

        this.element.appendChild(this.cloneDI);
    }

    #moveDragItem(mouseX, mouseY) {
        let l = mouseX - this.cloneOffsetX
        let t =  mouseY - this.cloneOffsetY
        this.cloneDI.style.left = l + 'px'
        this.cloneDI.style.top = t + 'px'
    }

    #findDropObject(event) {
        let el = document.elementFromPoint(event.x, event.y)
        let droppable = el.getAttribute("droppable") 
        if (!droppable || droppable == "false") {
          el = el.closest(`[droppable='true']`)
        }
        if (el && el.getAttribute("droppable") === "true" && el.getAttribute("data-viewtype") === this.cloneDI.getAttribute("data-viewtype")) {
            return el;
        }
    }

    #sendDropApi(apiPath, body) {
        const csrfToken = document.querySelector("[name='csrf-token']")?.content
        return fetch(apiPath, {
            method: 'PATCH',
            mode: 'cors',
            cache: 'no-cache',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': csrfToken,
            },
            body: JSON.stringify(body)
        }).then (response => {
            if (response.ok) {
                return response.text()
            } else {
                throw response.text()
            }
        })
    }

    #paddingStyle() {
        return `${this.cloneDI.getAttribute("data-viewtype")}-gap` // card-gap list-gap
    }

    #disDroppableCardItem(card) {
        card?.setAttribute("droppable", "false")
    }

    #blurCardItem(card) {
        card?.classList?.add("opacity-0")
    }

    #restoreCardItem(card) {
        card?.classList?.remove("opacity-0")
        card?.setAttribute("droppable", "true")
    }

    #revert(card) {
        if (this.preDropOverElement) this.preDropOverElement.classList.remove(this.#paddingStyle())
        this.#restoreCardItem(card)
        this.cloneDI.remove()
    }
}
