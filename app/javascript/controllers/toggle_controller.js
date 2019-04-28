import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'comments', 'toggle', 'link' ]

  toggle() {
    console.log("toggle")
    console.log(this.toggleTarget.classList)
    if(this.toggleTarget.classList.toggle("open")) {
      console.log("Set open")
      this.linkTarget.innerHTML = `[-]`
      this.commentsTarget.style = ""
    } else {
      console.log("Set closed")
      this.linkTarget.innerHTML = `[+] ${ this.commentsLabel() } collapsed`
      this.commentsTarget.style = "display: none;"
    }
  }

  commentsLabel() {
    let count = this.data.get('count');
    if ( count == 1 ) {
      return '1 reply';
    } else {
      return `${ count } replies`;
    }
  }
}