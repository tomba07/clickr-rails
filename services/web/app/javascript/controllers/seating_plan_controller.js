import { Controller } from 'stimulus'
import Rails from '@rails/ujs'
import websocketConsumer from '../channels/consumer'

// https://johnbeatty.co/2018/03/09/stimulus-js-tutorial-how-do-i-drag-and-drop-items-in-a-list/
export default class extends Controller {
  static targets = ['content']

  get endpoint() {
    return this.data.get('endpoint')
  }

  get rowOffset() {
    return this.data.get('row-offset')
  }

  get colOffset() {
    return this.data.get('col-offset')
  }

  get schoolClassId() {
    return this.data.get('school-class-id')
  }

  get browserWindowId() {
    return this.data.get('browser-window-id')
  }

  connect() {
    this.subscription = websocketConsumer.subscriptions.create(
      {
        channel: 'SchoolClassChannel',
        school_class_id: this.schoolClassId,
      },
      {
        received: ({ type, ...data }) => {
          console.debug(`Received ${type} websocket frame`, data)

          if (data.browser_window_id === this.browserWindowId) {
            console.debug(
              `Ignoring ${type} websocket frame caused by this browser window`
            )
            return
          }

          switch (type) {
            case 'response':
            case 'mapping':
            case 'seating_plan':
            case 'student':
              this.refresh()
              break
            // Question and lesson changed? Entire page reload needed anyway.
            case 'question':
            case 'lesson':
            default:
              console.debug(`Ignoring ${type} websocket frame`)
          }
        },
      }
    )
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  onDragStart(event) {
    const data = JSON.stringify({
      row: event.target.getAttribute('data-row'),
      col: event.target.getAttribute('data-col'),
    })
    event.dataTransfer.setData('application/drag-key', data)
    event.dataTransfer.effectAllowed = 'move'
  }

  onDragOver(event) {
    event.preventDefault()
    return true
  }

  onDragEnter(event) {
    event.preventDefault()
  }

  getPosition(el) {
    return [el.getAttribute('data-row'), el.getAttribute('data-col')]
  }

  getPositions() {
    const items = [...this.element.querySelectorAll('.seat--student')]
    return items.map(el => ({
      student_id: el.getAttribute('data-item-id'),
      seat_row: this.getPosition(el)[0],
      seat_col: this.getPosition(el)[1],
    }))
  }

  setPosition(el, [row, col]) {
    el.setAttribute('data-row', row)
    el.setAttribute('data-col', col)
    el.style['grid-row'] = row - parseInt(this.rowOffset)
    el.style['grid-column'] = col - parseInt(this.colOffset)
  }

  swap(el1, el2) {
    const el1Pos = this.getPosition(el1)
    const el2Pos = this.getPosition(el2)
    this.setPosition(el1, el2Pos)
    this.setPosition(el2, el1Pos)
  }

  onDrop(event) {
    const { row, col } = JSON.parse(
      event.dataTransfer.getData('application/drag-key')
    )
    const targetEl = event.target.closest('[data-row][data-col]')
    const sourceEl = this.element.querySelector(
      `[data-row='${row}'][data-col='${col}']`
    )
    this.swap(sourceEl, targetEl)
    event.preventDefault()
  }

  onStudentCreated(event) {
    this.refresh()
  }

  onStudentDeleted(event) {
    this.refresh()
  }

  onScoreAdjusted(event) {
    this.refresh()
  }

  refresh() {
    Rails.ajax({
      type: 'GET',
      url: this.endpoint,
      success: this.onSeatingPlanResponse,
    })
  }

  onSeatingPlanResponse = (response, status, xhr) => {
    // Replace only inner element, to keep this controller alive and avoid stimulus disconnect/connect cycle.
    this.contentTarget.replaceWith(response.querySelector('.seating-plan'))
  }

  submit(data) {
    Rails.ajax({
      url: this.endpoint,
      type: 'PUT',
      success: this.onSeatingPlanResponse,
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        // Workaround: add options.data late to avoid Content-Type header to already being set in stone
        // https://github.com/rails/rails/blob/master/actionview/app/assets/javascripts/rails-ujs/utils/ajax.coffee#L53
        options.data = JSON.stringify(data)
        return true
      },
    })
  }

  onDragEnd(event) {
    this.submit({
      students: this.getPositions(),
    })
  }
}
