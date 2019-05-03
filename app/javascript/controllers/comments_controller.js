import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {

  static targets = ["comments"]

  initialize() {
    let thisController = this;
    this.thisChannel = createChannel( "CommentsChannel", {
      connected() {
        thisController.listen()
      },
      received({ comments, parent_id, item_id }) {
        if (thisController.data.get('hn-id') == item_id ) {
          thisController.commentsTarget.innerHTML = comments
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
    
    if (this.thisChannel.consumer.connection.isOpen()) {
      this.thisChannel.perform('follow', { parent_id: this.data.get('hn-id') } )
    }
  }
}