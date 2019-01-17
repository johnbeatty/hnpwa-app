import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  initialize() {
    this.followedComments = new Set();
    let thisController = this;
    this.thisChannel = createChannel( "CommentsChannel", {
      connected() {
        thisController.listen(thisController.data.get('hn-id'))
      },
      received({ comments, parent_id, item_id }) {
        let existingItem = document.querySelector(`[data-hn-id='${ parent_id }']`)
        if (existingItem) {
          existingItem.innerHTML = comments
        }
      }
    });
  }

  connect() {
    this.listen(this.data.get('hn-id'))
  }

  disconnect() {
    if (this.thisChannel) {
      this.thisChannel.perform('unfollow')
    }
  }

  listen(hn_id) {
    if (this.thisChannel.consumer.connection.isOpen() && ! this.followedComments.has(hn_id)) {
      this.followedComments.add(hn_id)
      this.thisChannel.perform('follow', { parent_id: hn_id } )
    }
  }
}