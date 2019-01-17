import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [ 'metadata', 'commentsHeader' ]

  initialize() {
    this.followedComments = new Set();
    let thisController = this;
    this.thisChannel = createChannel( { channel: "ItemChannel",  }, {
      connected() {
        thisController.loadDetails()
      },
      received({ item_metadata, comments_header, item_id }) {
        if ( thisController.data.get("id") == item_id ) {
          thisController.metadataTarget.innerHTML = item_metadata; 
          thisController.commentsHeaderTarget.innerHTML = comments_header;
        }
      }
    });
  }

  connect() {
    this.loadDetails()
  }

  disconnect() {
    if (this.thisChannel) {
      this.thisChannel.perform('unfollow')
    }
  }

  loadDetails() {
    if (this.thisChannel) {
      this.thisChannel.perform('follow', { id: this.data.get("id") } )
    }
  }
}