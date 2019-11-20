import {Controller} from 'stimulus'

// https://johnbeatty.co/2018/03/09/stimulus-js-tutorial-how-do-i-drag-and-drop-items-in-a-list/
export default class extends Controller {
  static targets = ['output']

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

  setPosition(el, [row, col]) {
    el.setAttribute('data-row', row)
    el.setAttribute('data-col', col)
    el.style['grid-row'] = row
    el.style['grid-column'] = col
  }

  onDrop(event) {
    console.log(event)
    const { row, col } = JSON.parse(event.dataTransfer.getData("application/drag-key"))
    const targetEl = event.target.closest('[data-row][data-col]')
    const sourceEl = this.element.querySelector(`[data-row='${row}'][data-col='${col}']`)
    const targetPos = this.getPosition(targetEl)
    const sourcePos = this.getPosition(sourceEl)

    // Swap elements
    console.log('Swap', sourcePos, targetPos)
    this.setPosition(targetEl, sourcePos)
    this.setPosition(sourceEl, targetPos)

    event.preventDefault()
  }

  onDragEnd(event) {
    // TODO post updated seating plan
  }
}
