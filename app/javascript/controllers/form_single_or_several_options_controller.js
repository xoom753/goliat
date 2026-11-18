import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "radio",
        "singleOptions",
        "severalOptions"
    ]

    connect() {
        // first run
        this.updateSelection()
    }

    updateSelection(value = null) {
        if (!value) {
            const checkedInput = this.radioTargets.find(input => input.checked)
            value = checkedInput ? checkedInput.value : null
        }

        if (value == "single") {
            this.singleOptionsTarget.classList.remove("is-hidden")
            this.severalOptionsTarget.classList.add("is-hidden")
        } else {
            this.singleOptionsTarget.classList.add("is-hidden")
            this.severalOptionsTarget.classList.remove("is-hidden")
        }
    }

    changed(event) {
        const selectedValue = event.target.value
        this.updateSelection(selectedValue)
    }
}
