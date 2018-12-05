import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [  ]

  connect() {
    console.log(`job item id: ${this.data.get("id")}`);

    createChannel({ channel: "JobsChannel", job_item_id: this.data.get("id") }, {
      received({ message, job_item_id }) {
        let existingItem = document.querySelector(`[data-job-item-id='${ job_item_id }']`)
        if (existingItem) {
          existingItem.innerHTML = message
        }
      }
    });
  }
}