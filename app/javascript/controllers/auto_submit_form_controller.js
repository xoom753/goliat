import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "submitBtn",
    "selectTag"
  ]

  connect() {
    this.submitBtnTarget.hidden = true
    const submitForm = (e) => {
        this.element.submit()
    }
    this.selectTagTargets.forEach(tagTarget => {
      tagTarget.onchange = submitForm
    })
  }
}
