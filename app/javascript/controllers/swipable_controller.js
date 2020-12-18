// Huge thanks to Ana Tudor via https://codepen.io/thebabydino/pen/PRWqMg/ https://css-tricks.com/simple-swipe-with-vanilla-javascript/

const MOVE_PAGE_THRESHOLD = 0.3;

import { Controller } from "stimulus";
import Swipe from "swipejs";

export default class extends Controller {
  static targets = ["view"];

  initialize() {
    this.i = 0;
    this.x0 = null;
    this.locked = false;
    this.ini;
  }

  connect() {
    addEventListener("resize", this.size.bind(this), false);

    this.viewTarget.addEventListener("mousedown", this.lock.bind(this), false);
    this.viewTarget.addEventListener("touchstart", this.lock.bind(this), false);

    this.viewTarget.addEventListener("mouseup", this.move.bind(this), false);
    this.viewTarget.addEventListener("touchend", this.move.bind(this), false);

    this.mySwipe = new Swipe(this.viewTarget, {
      draggable: true,
      continuous: false,
    });

    this.size();
  }

  lock(event) {
    let initialX = unify(event).clientX;
    if (
      initialX < this.quarterWidth ||
      initialX + this.quarterWidth > this.width
    ) {
      this.x0 = initialX;
      this.locked = true;
    }
  }

  move(event) {
    if (this.locked) {
      let dx = unify(event).clientX - this.x0;
      let s = Math.sign(dx);
      let f = +((s * dx) / this.width).toFixed(2);

      this.ini = this.i - s * f;

      if (this.ini < -MOVE_PAGE_THRESHOLD) {
        window.history.back();
      } else if (this.ini > MOVE_PAGE_THRESHOLD) {
        window.history.forward();
      }

      if ((this.i > 0 || s < 0) && (this.i < 0 || s > 0) && f > 0.2) {
        this.i -= s;
        f = 1 - f;
      }

      this.x0 = null;
      this.locked = false;
    }
  }

  size() {
    this.width = window.innerWidth;
    this.quarterWidth = this.width * MOVE_PAGE_THRESHOLD;
  }
}

function easeInOut(k) {
  return 0.5 * (Math.sin((k - 0.5) * Math.PI) + 1);
}

function unify(event) {
  return event.changedTouches ? event.changedTouches[0] : event;
}
