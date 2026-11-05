import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "hiddenContent",
    "showDetails"
  ]

  connect() {
    this.showDetailsTarget.onclick = (e) => {
        e.preventDefault()
        this.showDetailsTarget.classList.add("is-hidden")
        this.showDetailsTarget.classList.remove("is-block")
        this.hiddenContentTarget.classList.remove("is-hidden")
    }
  }
}

