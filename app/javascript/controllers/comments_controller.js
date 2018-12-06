import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'comments', 'toggle', 'link' ]

  connect() {
    console.log(this.data.get("count") );
    console.log( this.commentsTarget );
    console.log( this.toggleTarget );
  }

  toggle() {
    console.log('toggle')
    if(this.toggleTarget.classList.toggle("open")) {
      this.linkTarget.innerHTML = `[-]`
      this.commentsTarget.style = ""
    } else {
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