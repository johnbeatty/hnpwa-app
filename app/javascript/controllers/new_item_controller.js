import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  connect() {
    console.log(`new item id: ${this.data.get("id")}`);

    createChannel({ channel: "NewNewsChannel", new_item_id: this.data.get("id") }, {
      received({ message, new_item_id }) {
        let existingItem = document.querySelector(`[data-new-item-id='${ new_item_id }']`)
        if (existingItem) {
          existingItem.innerHTML = message
        }
      }
    });
  }
}