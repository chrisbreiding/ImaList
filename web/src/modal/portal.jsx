import { Component } from 'react'
import { render, unmountComponentAtNode } from 'react-dom'

let idNum = 0

class Portal extends Component {
  constructor (...args) {
    super(...args)

    this.id = `portal-${idNum++}`
    this.hasEntered = false
  }

  componentWillUnmount () {
    this._unmount()
  }

  componentDidMount () {
    if (this.props.isShowing) {
      this._mount()
    }
  }

  componentDidUpdate ({ isShowing: wasShowing }) {
    if (!wasShowing && this.props.isShowing) {
      this._mount()
    }

    if (wasShowing && !this.props.isShowing) {
      this._unmount()
    }
  }

  _mount () {
    this._findOrCreateContainer()
    render(this.props.children, this.element)
    this._enter()
  }

  _findOrCreateContainer () {
    let element = document.getElementById(this.id)
    if (!element) {
      element = document.createElement('div')
      element.id = this.id
      document.body.appendChild(element)
    }
    this.element = element
  }

  _enter () {
    setTimeout(() => {
      this.element.className = 'has-entered'
    }, 50)
  }

  _unmount () {
    if (!this.element) return

    this.element.className = ''
    setTimeout(() => {
      unmountComponentAtNode(this.element)
      document.body.removeChild(this.element)
      this.element = null
    }, 350)
  }

  render () {
    return null
  }
}

export default Portal
