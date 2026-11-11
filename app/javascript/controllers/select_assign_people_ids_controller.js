import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
    connect() {
        this.select = new SlimSelect({
            select: this.element,
            settings: {
                placeholderText: 'Agregar persona…',
                searchPlaceholder: 'Nombre o DNI…'
            },
            events: {
                search: (searchValue, selected, catalog) => {
                    // Empty query: show the local baseline instead of fetching
                    if (searchValue === '') {
                        return catalog ?? []
                    }

                    // Otherwise fetch remote results
                    return fetch(`/api/people?q=${encodeURIComponent(searchValue)}`).then((r) => r.json())
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
