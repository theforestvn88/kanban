// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"

// import { StreamActions } from "@hotwired/turbo"
 
Turbo.StreamActions.move_before = function() {
    const moveViewId = this.getAttribute("move_view_id")
    const beforeViewId = this.getAttribute("before_view_id") 
    console.log(`move ${moveViewId} before ${beforeViewId}`)
    const moveView = document.getElementById(moveViewId)
    const beforeView = document.getElementById(beforeViewId)
    if (moveView && beforeView) {
        beforeView.before(moveView)
    }
}
