import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["comments", "toggle", "link"];
  static classes = ["open"];
  static values = { count: Number };
  toggle() {
    if (this.toggleTarget.classList.toggle(this.openClass)) {
      this.linkTarget.innerHTML = `[-]`;
      this.commentsTarget.style = "";
    } else {
      this.linkTarget.innerHTML = `[+] ${this.commentsLabel()} collapsed`;
      this.commentsTarget.style = "display: none;";
    }
  }

  commentsLabel() {
    let count = this.countValue;
    if (count == 1) {
      return "1 reply";
    } else {
      return `${count} replies`;
    }
  }
}
