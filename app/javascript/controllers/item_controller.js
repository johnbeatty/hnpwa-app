import { Controller } from "stimulus";
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = ["metadata", "commentsHeader", "progress"];
  static values = { id: String };

  initialize() {
    let thisController = this;
    this.thisChannel = createChannel(
      { channel: "ItemChannel" },
      {
        connected() {
          thisController.loadDetails();
        },
        received({ item, comments_header, progress, item_id }) {
          if (thisController.idValue == item_id) {
            if (item) {
              thisController.metadataTarget.innerHTML = item;
            }
            if (comments_header) {
              thisController.commentsHeaderTarget.innerHTML = comments_header;
            }
            if (progress) {
              thisController.progressTarget.value = progress;
            }
          }
        },
      }
    );
  }

  connect() {
    this.loadDetails();
  }

  disconnect() {
    if (this.thisChannel) {
      this.thisChannel.perform("unfollow");
    }
  }

  loadDetails() {
    if (this.thisChannel) {
      this.thisChannel.perform("follow", { id: this.idValue });
    }
  }
}
