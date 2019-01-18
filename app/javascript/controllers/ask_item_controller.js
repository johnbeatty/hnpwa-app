import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  initialize() {
    let thisController = this;
    this.channel = createChannel( "AskItemChannel", {
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
      let locations = []
      for (const value of document.querySelectorAll(`[data-location]`)) {
        locations.push(  value.getAttribute('data-location') )
      }
      this.channel.perform('follow', { locations: locations } )
    }
  }
}