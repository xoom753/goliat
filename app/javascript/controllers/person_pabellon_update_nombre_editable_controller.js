import { Controller } from "@hotwired/stimulus"
import { put } from "@rails/request.js"

export default class extends Controller {
    static values = {
        pabellonUpdate: Number
    }

    update() {
        const nombres = this.element.innerText
        put(
            `/person_pabellon_updates/${this.pabellonUpdateValue}`, {
                body: { nombres: nombres }
        })
    }

    willUpdate() {
        if (this.timeout) {
            clearTimeout(this.timeout)
        }

        this.timeout = setTimeout( (e) => {
            this.update();
        }, 500);
    }
}
