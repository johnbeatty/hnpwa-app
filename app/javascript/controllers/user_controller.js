import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [ 'metadata' ]

  connect() {
    console.log(`user id: ${this.data.get("id")}`);
    let userController = this;
    console.log(userController.metadataTarget)
    createChannel({ channel: "UserChannel", user_id: this.data.get("id") }, {
      received({ user_metadata, user_id }) {
        console.log('received')
        console.log(user_metadata)
        console.log(user_id)
        userController.metadataTarget.innerHTML = user_metadata 
      }
    });
  }
}