import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  initialize() {
    let thisController = this;
    this.thisChannel = createChannel( "AskItemChannel", {
      connected() {
        thisController.listen()
      },
      received({ message, location }) {
        let existingItem = document.querySelector(`[data-location='${ location }']`)
        if (existingItem) {
          existingItem.innerHTML = message
        }
      }
    });
  }

  connect() {
    this.listen()
  }

  disconnect() {
    if (this.thisChannel) {
      this.thisChannel.perform('unfollow')
    }
  }

  listen() {
    if (this.thisChannel) {
      this.thisChannel.perform('follow', { locations: this.data.get('locations') } )
    }
  }
}