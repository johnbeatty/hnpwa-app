import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  connect() {
    console.log(`show item id: ${this.data.get("id")}`);

    createChannel({ channel: "ShowNewsChannel", show_item_id: this.data.get("id") }, {
      received({ message, show_item_id }) {
        let existingItem = document.querySelector(`[data-show-item-id='${ show_item_id }']`)
        if (existingItem) {
          existingItem.innerHTML = message
        }
      }
    });
  }
}