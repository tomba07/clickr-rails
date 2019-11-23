import {Controller} from 'stimulus'

// CSS animations fail to completely remove an element with dynamic height (display: none)
// https://w3bits.com/labs/javascript-slidetoggle/
export default class extends Controller {
  connect() {
    setTimeout(() => this.slideUp(this.element, 500), 2000)
  }

  slideUp(t = this.element, duration = 500) {
    const s = t.style
    s.transitionProperty = 'height, margin, padding'
    s.transitionDuration = duration + 'ms'
    s.boxSizing = 'border-box'
    s.height = t.offsetHeight + 'px'
    s.overflow = 'hidden'
    s.height = 0
    s.paddingTop = 0
    s.paddingBottom = 0
    s.marginTop = 0
    s.marginBottom = 0
    setTimeout( () => {
      s.display = 'none'
      s.removeProperty('height')
      s.removeProperty('padding-top')
      s.removeProperty('padding-bottom')
      s.removeProperty('margin-top')
      s.removeProperty('margin-bottom')
      s.removeProperty('overflow')
      s.removeProperty('transition-duration')
      s.removeProperty('transition-property')
    }, duration)
  }
}
