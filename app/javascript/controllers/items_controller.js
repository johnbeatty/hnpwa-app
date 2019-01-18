import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  initialize() {

    let thisController = this;
    this.channel = createChannel( "ItemsListChannel", {
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
    if (this.channel) {
      this.channel.perform('unfollow')
    }
  }

  listen() {
    if (this.channel) {
      let items = []
      for (const value of document.querySelectorAll(`[data-item-id]`)) {
        items.push( value.getAttribute('data-item-id') )
      }
      this.channel.perform('follow', { items: items } )
    }
  }
}