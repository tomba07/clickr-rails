import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['field', 'decrement']

  connect() {
    this.refresh()
  }

  get value() {
    return parseInt(this.fieldTarget.value)
  }

  increment() {
    this.fieldTarget.value = this.value + 1
    this.refresh()
  }

  decrement() {
    this.fieldTarget.value = Math.max(this.value - 1, 1)
    this.refresh()
  }

  refresh() {
    this.decrementTarget.disabled = this.value <= 1
  }
}
