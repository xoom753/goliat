import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "submitBtn",
    "selectTag"
  ]

  connect() {
    this.submitBtnTarget.hidden = true
    this.selectTagTarget.onchange = (e) => {
        this.element.submit()
    }
  }
}
