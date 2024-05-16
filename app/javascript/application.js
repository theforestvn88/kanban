// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"

// import { StreamActions } from "@hotwired/turbo"
 
Turbo.StreamActions.move_before = function() {
    const fromViewId = this.getAttribute("from_view_id")
    const toViewId = this.getAttribute("to_view_id") 
    console.log(`move ${fromViewId} ${toViewId}`)
    const fromView = document.getElementById(fromViewId)
    const toView = document.getElementById(toViewId)
    if (fromView && toView) {
        toView.before(fromView)
    }
}
