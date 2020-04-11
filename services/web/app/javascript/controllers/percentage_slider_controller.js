import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['label', 'input']

  connect() {
    this.onDragged()
  }

  onDragged() {
    this.labelTarget.innerHTML = `${(
      100.0 * this.inputTarget.valueAsNumber
    ).toFixed(0)}%`
  }
}
