// Huge thanks to Ana Tudor via https://codepen.io/thebabydino/pen/PRWqMg/ https://css-tricks.com/simple-swipe-with-vanilla-javascript/

const NUMBER_OF_FRAMES = 30;
const MOVE_PAGE_THRESHOLD = 0.3;
const STOP_VERTICAL_MOVEMENT_THRESHOLD = 0.02;
import { Controller } from 'stimulus';

export default class extends Controller {

    static targets = ['view']

    initialize() {
      this.i = 0; 
      this.x0 = null; 
      this.locked = false;
      this.ini; 
      this.fin; 
      this.rID = null; 
      this.anf;
      this.n;
    }

    connect() {
      addEventListener('resize', this.size.bind(this), false);
      addEventListener('turbolinks:before-cache', this.reset.bind(this), false);

      this.element.addEventListener('mousedown', this.lock.bind(this), false);
      this.element.addEventListener('touchstart', this.lock.bind(this), false);

      this.element.addEventListener('mousemove', this.drag.bind(this), false);
      this.element.addEventListener('touchmove', this.drag.bind(this), false);

      this.element.addEventListener('mouseup', this.move.bind(this) , false);
      this.element.addEventListener('touchend', this.move.bind(this), false);

      this.size();
    }

    lock(event) {
      let initialX = unify(event).clientX;
      if (initialX < this.quarterWidth 
        || initialX + this.quarterWidth > this.width ) {
        this.x0 = initialX;
        this.locked = true
      }
    }

    drag(event) {
      if(this.locked) {
        let dx = unify(event).clientX - this.x0;
        let f = +(dx/this.width).toFixed(2);
        let calculation = this.i - f;
        console.log(`${ calculation } - ${ STOP_VERTICAL_MOVEMENT_THRESHOLD }`);
        console.log(`${ calculation > STOP_VERTICAL_MOVEMENT_THRESHOLD  } - ${ calculation < -STOP_VERTICAL_MOVEMENT_THRESHOLD }`);
        this.viewTarget.style.setProperty('--i', `${ calculation }`)
        if (calculation > STOP_VERTICAL_MOVEMENT_THRESHOLD 
          || calculation < -STOP_VERTICAL_MOVEMENT_THRESHOLD ) {
          console.log('stopping event...')
          event.preventDefault();
        }
      }
    }

    move(event) {
      if(this.locked) {
        let dx = unify(event).clientX - this.x0;
        let s = Math.sign(dx); 
        let f = +(s*dx/this.width).toFixed(2);
      
        this.ini = this.i - s*f;

        if ( this.ini < -MOVE_PAGE_THRESHOLD ) {
          window.history.back();
        } else if ( this.ini > MOVE_PAGE_THRESHOLD) {
          window.history.forward();
        }
        
        if((this.i > 0 || s < 0) && (this.i < 0 || s > 0) && f > .2) {
          this.i -= s;
          f = 1 - f
        }
      
        this.fin = this.i;
        this.anf = Math.round(f*NUMBER_OF_FRAMES);
        this.n = 2 + Math.round(f)
        this.ani();
        this.x0 = null;
        this.locked = false;
      }
    }

    stopAni() {
      cancelAnimationFrame(this.rID);
      this.rID = null
    };


    ani(cf = 0) {
      this.viewTarget.style.setProperty('--i', `${ this.ini + (this.fin - this.ini) * easeInOut(cf/this.anf) }`);

      if(cf === this.anf) {
        this.stopAni();
        return
      }

      this.rID = requestAnimationFrame(this.ani.bind(this, ++cf))
    }

    size() {
      this.width = window.innerWidth;
      this.quarterWidth = this.width * MOVE_PAGE_THRESHOLD;
    }

    reset() {
      this.viewTarget.style.setProperty('--i', 0);
    }
}

function easeInOut(k) {
  return .5*(Math.sin((k - .5)*Math.PI) + 1);
}

function unify(event) { 
  return event.changedTouches ? event.changedTouches[0] : event;
}
