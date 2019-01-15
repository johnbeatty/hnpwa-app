import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  initialize() {

    let itemsController = this;
    this.itemsChannel = createChannel( "ItemsChannel", {
      connected() {
        itemsController.listen()
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
    if (this.itemsChannel) {
      this.itemsChannel.perform('unfollow')
    }
  }

  listen() {
    if (this.itemsChannel) {
      this.itemsChannel.perform('follow_items', { items: this.data.get('items') } )
    }
  }
}