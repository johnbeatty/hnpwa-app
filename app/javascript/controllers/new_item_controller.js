import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  initialize() {
    let newItemController = this;
    this.newNewsChannel = createChannel( "NewNewsChannel", {
      connected() {
        console.log('connected')
        newItemController.listen()
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
    this.newNewsChannel.perform('unfollow')
  }

  listen() {
    if (this.newNewsChannel) {
      this.newNewsChannel.perform('follow', { locations: this.data.get('locations') } )
    }
  }
}