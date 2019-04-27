import { Controller } from 'stimulus'

export default class extends Controller {

    static targets = ['burger', 'menu'];

    toggle(event) {
        this.burgerTarget.classList.toggle('is-active');
        this.menuTarget.classList.toggle('is-active');
    }
}