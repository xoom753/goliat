import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
    static targets = [
        "yearOutput",
        "monthOutput"
    ]
    // @property({ type: String }) declare currentYear: String;

    // declare currentYear: string

    // declare currentYear: String;

    // default = {
        // currentYear: String
    // }

    // currentYear = Number
    // currentMonth = Number

    connect() {
        this.formAction = this.element.action
    }

    update(e) {
        const yearValue = this.yearInputTarget.value
        const monthValue = this.monthInputTarget.value
        console.log("yearValue")
        console.log(yearValue)
        console.log(monthValue)
    }

    input(e) {
        if (this.delayedYear) {
            clearTimeout(this.delayedYear)
        }
        if (this.delayedMonth) {
            clearTimeout(this.delayedMonth)
        }
        if (this.delayedSubmit) {
            clearTimeout(this.delayedSubmit)
        }

        this.currentYear = this.yearOutputTarget.innerText
        this.currentMonth = this.monthOutputTarget.innerText

        if (!this.currentYear) {
            this.delayedYear = setTimeout(()=>{
                this.yearOutputTarget.innerText = "-"
            }, 500)
        }

        if (!this.currentMonth) {
            this.delayedMonth = setTimeout(()=>{
                this.monthOutputTarget.innerText = "-"
            }, 500)
        }

        this.delayedSubmit = setTimeout(() => {
            post(
                this.formAction, {
                    body: {
                        year: this.currentYear,
                        month: this.currentMonth
                    }
                }
            )
        }, 500)
    }
}
