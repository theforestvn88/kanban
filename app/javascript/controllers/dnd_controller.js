import { Controller } from "@hotwired/stimulus"

// drag and drop controller
export default class extends Controller {
    connect() {
        console.log("DnD controller ...")
        this.shadow = document.createElement("div")
        this.shadow.setAttribute("id", "shadow")
        this.shadow.classList.add("px-10", "py-5", "m-5", "border", "border-dashed", "border-indigo-300")
    }

    dragStart(event) {
        console.log("DRAG START ..................")
        const [dragObjectType, dragObjectId] = event.target.id.split("_")
        event.dataTransfer.setData("id", dragObjectId)
        event.dataTransfer.setData("type", dragObjectType)
        event.dataTransfer.effectAllowed = "move"

        this.#cloneDragItem(event.target, event.x, event.y)
        // this.#blurItem(event.target)
        this.#disableDroppableItem(event.target)
    }

    dragOver(event) {
    console.log("DRAG OVER ...")
        this.#moveDragItem(event.x, event.y)

        this.cloneDI.classList.add("hidden")
        let dropEl = this.#findDropObject(event)
        console.log(dropEl)
        if (dropEl) {
            // if (this.dropOverElement) this.dropOverElement.classList.remove(this.#paddingStyle())
            if (dropEl.getAttribute("id") != "shadow") {
                this.dropOverElement = dropEl
            // this.dropOverElement.classList.add(this.#paddingStyle())
console.log(this.dropOverElement.parentNode)
                this.shadow.setAttribute("id", this.dropOverElement.getAttribute("id"))
                this.shadow.setAttribute("droppable", true)
            this.dropOverElement.parentNode.insertBefore(this.shadow, this.dropOverElement)
            } 
        } else {
            this.dropOverElement = null
            this.shadow.remove()
        }
        this.cloneDI.classList.remove("hidden")

        event.preventDefault()
        return false
    }

    dragLeave(event) {}

    dragEnter(event) {}

    drop(event) {
        console.log("DROP ...")
        const dragObjectType = event.dataTransfer.getData("type")
        const dragObjectId = event.dataTransfer.getData("id")

        this.cloneDI.classList.add("hidden")
        // let dropTarget = this.#findDropObject(event)
        if (this.dropOverElement) {
            if (this.dropOverElement) this.dropOverElement.classList.remove(this.#paddingStyle())
            const [dropType, dropId] = this.dropOverElement.getAttribute("id").split("_")
        console.log(`DROP ${[dropType, dropId]}`)
            if (dropType != dragObjectType) return
            // const currPos = parseFloat(dropTarget.getAttribute("data-currpos"))
            // const prevPos = parseFloat(dropTarget.getAttribute("data-prevpos"))
            // const parentKey = dropTarget.getAttribute("data-parentkey")
            // const parentId = dropTarget.getAttribute("data-parentid")

            const dropBody = { 
                type: dragObjectType,
                drag_id: dragObjectId,
                drop_id: dropId
            }
            // dropBody["user-action"] = "move"
            // dropBody[`${dragObjectType}`] = {}
            // if (parentId) dropBody[`${dragObjectType}`][`${parentKey}`] = `${parentId}`
            // if (currPos) {
            //     dropBody[`${dragObjectType}`]["position"] = `${(currPos + prevPos)/2}`
            // } else {
            //     dropBody["prev_position"] = `${prevPos}`
            // }
            // if (dropId) dropBody["next_view_id"] = `${dropId}`

            this.#sendDropApi(`/kanban/dnd_${dragObjectType}.turbo_stream`, dropBody)
                .then(html => {
                    this.#revert(document.getElementById(`${dragObjectType}_${dragObjectId}`))    
                    Turbo.renderStreamMessage(html)
                    this.cloneDI.remove()
                    this.shadow.remove()
                })
                .catch(error => {
                    console.log("DnD ERROR")
                    console.log(error)
                    error.then(html => {
                        console.log(html)
                        Turbo.renderStreamMessage(html)
                    })
                    
                    this.#revert(document.getElementById(`${dragObjectType}_${dragObjectId}`))
                    this.shadow.remove()
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
        this.cloneDI.setAttribute("viewType", dragItem.getAttribute("id").split("_")[0])
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
        if (el.getAttribute("id") == "shadow") return el

        let droppable = el.getAttribute("droppable") 
        if (!droppable || droppable == "false") {
          el = el.closest(`[droppable='true']`)
        }
        console.log(el)
        if (el && el.getAttribute("id").split("_")[0] == this.cloneDI.getAttribute("viewType")) {
            return el;
        }
    }

    #sendDropApi(apiPath, body) {
        const csrfToken = document.querySelector("[name='csrf-token']")?.content
        return fetch(apiPath, {
            method: 'POST',
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
        let s = this.cloneDI.getAttribute("viewType")
        console.log(s)
        return `${s}-gap` // card-gap list-gap
    }

    #disableDroppableItem(item) {
        item?.setAttribute("droppable", "false")
        item?.classList?.add("opacity-0")
    }

    // #blurItem(item) {
    //     item?.classList?.add("opacity-0")
    // }

    #enableDroppableItem(card) {
        card?.classList?.remove("opacity-0")
        card?.setAttribute("droppable", "true")
    }

    #revert(item) {
        if (this.dropOverElement) this.dropOverElement.classList.remove(this.#paddingStyle())
        this.#enableDroppableItem(item)
        this.cloneDI.remove()
    }
}