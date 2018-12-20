import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [ 'metadata', 'comments' ]

  connect() {
    console.log(`item id: ${this.data.get("id")}`);
    let itemController = this;
    console.log(itemController.metadataTarget)
    createChannel({ channel: "ItemsChannel", item_id: this.data.get("id") }, {
      received({ item_metadata, item_id }) {
        console.log('received')
        console.log(item_metadata)
        console.log(item_id)
        itemController.metadataTarget.innerHTML = item_metadata 
      }
    });
  }
}