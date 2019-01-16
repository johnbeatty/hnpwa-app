import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  initialize() {
    let showItemController = this;
    this.showNewsChannel = createChannel( "ShowNewsChannel", {
      connected() {
        showItemController.listen()
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
    if (this.showNewsChannel) {
      this.showNewsChannel.perform('unfollow')
    }
  }

  listen() {
    if (this.showNewsChannel) {
      this.showNewsChannel.perform('follow', { locations: this.data.get('locations') } )
    }
  }
}