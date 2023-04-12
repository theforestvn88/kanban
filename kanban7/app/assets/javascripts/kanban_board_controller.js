import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "addListBtn", "formList" ]
    static values = { name: String }

    connect() {
        console.log(`${this.nameValue} Board Controller connected !!!`)
        this.root = document.documentElement;
    }

    showListForm() {
        this.addListBtnTarget.classList.add("hidden")
        this.formListTarget.classList.remove("hidden")
    }

    // drag and drop
  
    dragStart(event) {
        console.log("DRAG START ....")
        const [dragObject, dragObjectId] = event.target.id.split("_")
        event.dataTransfer.setData("id", dragObjectId)
        event.dataTransfer.setData("type", dragObject)
        event.dataTransfer.effectAllowed = "move"

        this.#cloneDragItem(event.target, event.x, event.y)
        event.target.classList.add("hidden")
    }

    dragOver(event) {
        console.log("DRAG OVER ....")
        this.#moveDragItem(event.x, event.y)
        
        const dragObjectType = event.dataTransfer.getData("type")
        this.cloneDI.classList.add("hidden")
        let dropEl = this.#findDropObject(event.x, event.y, dragObjectType)
        if (dropEl) {
            if (this.preDropOverElement) this.preDropOverElement.classList.remove(this.#paddingStyle(dragObjectType))
            this.preDropOverElement = dropEl
            this.preDropOverElement.classList.add(this.#paddingStyle(dragObjectType))
        }
        this.cloneDI.classList.remove("hidden")

        event.preventDefault()
        return true
    }

    dragLeave(event) {}

    dragEnter(event) {
        event.preventDefault()
    }

    drop(event) {
        const dragObjectType = event.dataTransfer.getData("type")
        const dragObjectId = event.dataTransfer.getData("id")

        this.cloneDI.classList.add("hidden")
        let dropTarget = this.#findDropObject(event.x, event.y, dragObjectType)
        if (dropTarget) {
            if (this.preDropOverElement) this.preDropOverElement.classList.remove(this.#paddingStyle(dragObjectType))
            const dropId = dropTarget.getAttribute("id")
            const currPos = parseFloat(dropTarget.getAttribute("data-currpos"))
            const prevPos = parseFloat(dropTarget.getAttribute("data-prevpos"))
            const listType = dropTarget.getAttribute("data-listtype")
            const listId = dropTarget.getAttribute("data-listid")

            const dropBody = {}
            dropBody[`${dragObjectType}`] = {}
            if (listId) dropBody[`${dragObjectType}`][`${listType}_id`] = `${listId}`
            dropBody[`${dragObjectType}`]["position"] = `${(currPos + prevPos)/2}`
            dropBody["next_view_id"] = `${dropId}`

            this.#sendDropApi(`/kanban7/${this.nameValue}/${dragObjectType}s/${dragObjectId}`, dropBody)
                .then (response => response.text())
                .then(html => Turbo.renderStreamMessage(html))
                .catch(error => {
                    console.log(error)
                    document.getElementById(`${dragObjectType}_${dragObjectId}`)?.classList?.remove("hidden")
                })
        }

        event.preventDefault()
    }

    dragEnd(event) {
        console.log("DROP END ....")
    }

    // private

    #cloneDragItem(dragItem, mouseX, mouseY) {
        var rect = dragItem.getBoundingClientRect();
        this.cloneDI = dragItem.cloneNode(true);
        this.cloneDI.setAttribute("droppable", "false")
        this.cloneDI.style["width"] = rect.width + 'px';
        this.cloneDI.style["height"] = rect.height + 'px';
        this.cloneDI.style["top"] = rect.top + 'px';
        this.cloneDI.style["left"] = rect.left + 'px';
        this.cloneDI.classList.add("z-50", "fixed", "rotate-3")

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

    #findDropObject(mouseX, mouseY, objectType) {
        let el = document.elementFromPoint(mouseX, mouseY)
        let droppable = el.getAttribute("droppable") 
        if (!droppable || droppable == "false") {
          el = el.closest(`[droppable='true']`)
        }
        if (el && el.getAttribute("droppable") === "true" && el.getAttribute("id").split("_")[0] === objectType) {
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
        })
    }

    #paddingStyle(dragObjectType) {
        return dragObjectType === "card" ? "pt-14" : "pl-60"
    }
}