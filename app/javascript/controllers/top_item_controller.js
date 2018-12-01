import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  connect() {
    console.log(`top item id: ${this.data.get("id")}`);

    createChannel({ channel: "TopNewsChannel", top_item_id: this.data.get("id") }, {
      received({ message, top_item_id }) {
        let existingItem = document.querySelector(`[data-top-item-id='${ top_item_id }']`)
        if (existingItem) {
          existingItem.innerHTML = message
        }
      }
    });
  }
}