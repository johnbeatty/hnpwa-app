// Huge thanks to Ana Tudor via https://codepen.io/thebabydino/pen/PRWqMg/ https://css-tricks.com/simple-swipe-with-vanilla-javascript/

const NUMBER_OF_FRAMES = 30;
import { Controller } from 'stimulus';

export default class extends Controller {

    static targets = ['view']

    initialize() {
        console.log('initialize')

        this.i = 0; 
        this.x0 = null; 
        this.locked = false; 
        this.w; 
        this.ini; 
        this.fin; 
        this.rID = null; 
        this.anf;
        this.n;
        this.N = 1;
    }

    connect() {
        console.log('connect')

        addEventListener('resize', this.size.bind(this), false);

        this.element.addEventListener('mousedown', this.lock.bind(this), false);
        this.element.addEventListener('touchstart', this.lock.bind(this), false);

        this.element.addEventListener('mousemove', this.drag.bind(this), false);
        this.element.addEventListener('touchmove', this.drag.bind(this), false);

        this.element.addEventListener('mouseup', this.move.bind(this) , false);
        this.element.addEventListener('touchend', this.move.bind(this), false);

        this.size();
    }

    disconnect() {
        console.log('disconnect')
    }

    lock(event) {
      console.log('lock');
      this.x0 = unify(event).clientX;
      this.locked = true
    }

    drag(event) {
      if(this.locked) {
          console.log('drag');
          event.preventDefault();
          let dx = unify(event).clientX - this.x0;
          let f = +(dx/this.width).toFixed(2);
          console.log(`drag dx: ${dx} i: ${this.i} f: ${f} calculation: ${ this.i - f }`);
          this.viewTarget.style.setProperty('--i', `${ this.i - f }`)
        }
    }


    move(event) {

      console.log('move');
        if(this.locked) {
          let dx = unify(event).clientX - this.x0;
          let s = Math.sign(dx); 
          let f = +(s*dx/this.width).toFixed(2);
      
          this.ini = this.i - s*f;
      
          if((this.i > 0 || s < 0) && (this.i < this.N - 1 || s > 0) && f > .2) {
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

    size() {
        this.width = window.innerWidth;
    }

    stopAni() {
      cancelAnimationFrame(this.rID);
      this.rID = null
    };


    ani(cf = 0) {
      console.log(`ani ini: ${this.ini } fin: ${  this.fin } easeOut: ${ this.easeInOut(cf/this.anf) } cf: ${ cf } anf: ${ this.anf } `);
      console.log(`ani ${this.ini + (this.fin - this.ini) * this.easeInOut(cf/this.anf)}`);
      
      this.viewTarget.style.setProperty('--i', `${ this.ini + (this.fin - this.ini) * this.easeInOut(cf/this.anf) }`);

      if(cf === this.anf) {
        this.stopAni();
        return
      }

      this.rID = requestAnimationFrame(this.ani.bind(this, ++cf))
    }

    bounceOut(k, a = 2.75, b = 1.5) {
      return 1 - Math.pow(1 - k, a)*Math.abs(Math.cos(Math.pow(k, b)*(this.n + .5)*Math.PI))
    }

    easeInOut(k) {
          return .5*(Math.sin((k - .5)*Math.PI) + 1)
    }
}

function unify(event) { 
  return event.changedTouches ? event.changedTouches[0] : event;
};
