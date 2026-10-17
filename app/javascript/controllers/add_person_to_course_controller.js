import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  static targets = ["select", "form", "personInput"]

  connect() {
    this.select = new SlimSelect({
      select: this.selectTarget,
      settings: {
        placeholderText: 'Add person…',
        searchPlaceholder: 'Name or DNI…'
      },
      events: {
        search: (searchValue, selected, catalog) => {
            // Empty query: show the local baseline instead of fetching
            if (searchValue === '') {
                return catalog ?? []
            }

            // Otherwise fetch remote results
            return fetch(`/api/people?q=${encodeURIComponent(searchValue)}`).then((r) => r.json())
        },
        afterChange: (newVal) => { 
          this.personInputTarget.value = newVal[0].value;
          this.formTarget.submit()
        }
      }
    })
  }

  disconnect() {
    if (this.select) {
      this.select.destroy()
    }
  }
}
