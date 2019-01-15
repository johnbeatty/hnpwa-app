import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  initialize() {

    let topItemsController = this;
    this.topNewsChannel = createChannel( "TopNewsChannel", {
      connected() {
        console.log('connected')
        topItemsController.listen()
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
    this.topNewsChannel.perform('unfollow')
  }

  listen() {
    if (this.topNewsChannel) {
      this.topNewsChannel.perform('follow', { locations: this.data.get('locations') } )
    }
  }
}