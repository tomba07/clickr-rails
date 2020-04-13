import { Controller } from 'stimulus'
import shuffle from 'lodash/shuffle'

export default class extends Controller {
  static targets = ['student', 'studentThatResponded']

  get durationMs() {
    return Number.parseInt(this.data.get('duration-ms')) || 3000
  }

  connect() {
    const button = document.getElementById('rollTheDiceButton')
    if (button) {
      button.addEventListener('click', this.rollTheDice.bind(this))
    }
  }

  async rollTheDice() {
    const intermediateClass = 'has-background-warning'
    const finalClass = 'has-background-danger'
    const shuffledResponses = shuffle(this.studentThatRespondedTargets)
    const durationPerStudent = this.durationMs / shuffledResponses.length

    this.studentTargets.forEach(s => {
      s.classList.remove(intermediateClass, finalClass)
    })

    for (const [i, student] of shuffledResponses.entries()) {
      const isLast = i == shuffledResponses.length - 1
      student.classList.add(isLast ? finalClass : intermediateClass)
      await sleep(durationPerStudent)
      student.classList.remove(intermediateClass)
    }
  }
}

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms))
