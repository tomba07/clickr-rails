import {Controller} from 'stimulus'
import Rails from '@rails/ujs'

// https://johnbeatty.co/2018/03/09/stimulus-js-tutorial-how-do-i-drag-and-drop-items-in-a-list/
export default class extends Controller {
  onDragStart(event) {
    this.element.classList.add('grid--dragging')
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
    const items = [...this.element.querySelectorAll('.grid__item[draggable]')]
    return items.map(el => ({
      student_id: el.getAttribute('data-item-id'),
      row: this.getPosition(el)[0],
      col: this.getPosition(el)[1],
    }))
  }

  setPosition(el, [row, col]) {
    el.setAttribute('data-row', row)
    el.setAttribute('data-col', col)
    el.style['grid-row'] = row
    el.style['grid-column'] = col
  }

  swap(el1, el2) {
    const el1Pos = this.getPosition(el1)
    const el2Pos = this.getPosition(el2)
    this.setPosition(el1, el2Pos)
    this.setPosition(el2, el1Pos)
  }

  onDrop(event) {
    const { row, col } = JSON.parse(event.dataTransfer.getData("application/drag-key"))
    const targetEl = event.target.closest('[data-row][data-col]')
    const sourceEl = this.element.querySelector(`[data-row='${row}'][data-col='${col}']`)
    this.swap(sourceEl, targetEl)
    event.preventDefault()
  }

  submit(data) {
    Rails.ajax({
      url: this.data.get('endpoint'),
      type: 'put',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        // Workaround: add options.data late to avoid Content-Type header to already being set in stone
        // https://github.com/rails/rails/blob/master/actionview/app/assets/javascripts/rails-ujs/utils/ajax.coffee#L53
        options.data = JSON.stringify(data)
        return true
      },
    });
  }

  onDragEnd(event) {
    this.element.classList.remove('grid--dragging')
    this.submit({
      school_class: {
        students: this.getPositions()
      }
    })
  }
}
