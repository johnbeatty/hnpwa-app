import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  initialize() {

    let thisController = this;
    this.thisChannel = createChannel( "ItemsListChannel", {
      connected() {
        thisController.listen()
      },
      received({ item, item_id }) {
        let existingItem = document.querySelector(`[data-item-id='${ item_id }']`)
        if (existingItem) {
          let html = new DOMParser().parseFromString( item , 'text/html');
          const itemHTML = html.body.firstChild;
          existingItem.parentNode.replaceChild(itemHTML, existingItem);
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
      this.thisChannel.perform('follow', { items: this.data.get('items') } )
    }
  }
}