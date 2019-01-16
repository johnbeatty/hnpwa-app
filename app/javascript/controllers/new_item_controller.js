import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  initialize() {
    let thisController = this;
    this.channel = createChannel( "NewItemChannel", {
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
    if (this.channel) {
      this.channel.perform('unfollow')
    }
  }

  listen() {
    if (this.channel) {
      this.channel.perform('follow', { locations: this.data.get('locations') } )
    }
  }
}