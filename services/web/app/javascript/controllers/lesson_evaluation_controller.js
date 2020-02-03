import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['benchmarkLabel']

  get seatingPlanController() {
    const seatingPlan = document.querySelector('.seating-plan-controller')
    return this.application.getControllerForElementAndIdentifier(
      seatingPlan,
      'seating-plan'
    )
  }

  set benchmark(value) {
    this._benchmark = value
    this.benchmarkLabelTarget.innerHTML = value
  }

  get benchmark() {
    return this._benchmark
  }

  get endpoint() {
    return this.data.get('endpoint')
  }

  onBenchmarkChanged(event) {
    this.benchmark = event.target.valueAsNumber

    const data = {
      benchmark: this.benchmark,
    }

    Rails.ajax({
      type: 'PUT',
      url: this.endpoint,
      success: () => this.seatingPlanController.refresh(),
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        // Workaround: add options.data late to avoid Content-Type header to already being set in stone
        // https://github.com/rails/rails/blob/master/actionview/app/assets/javascripts/rails-ujs/utils/ajax.coffee#L53
        options.data = JSON.stringify(data)
        return true
      },
    })
  }

  onBenchmarkDragged(event) {
    this.benchmark = event.target.valueAsNumber
  }
}
