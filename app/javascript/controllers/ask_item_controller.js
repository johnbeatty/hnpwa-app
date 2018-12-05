import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  connect() {
    createChannel({ channel: "AskNewsChannel", ask_item_id: this.data.get("id") }, {
      received({ message, ask_item_id }) {
        let existingItem = document.querySelector(`[data-ask-item-id='${ ask_item_id }']`)
        if (existingItem) {
          existingItem.innerHTML = message
        }
      }
    });
  }
}