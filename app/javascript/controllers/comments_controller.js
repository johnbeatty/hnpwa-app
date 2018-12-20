import { Controller } from "stimulus"
import createChannel from "cables/cable";

export default class extends Controller {
  static targets = [ 'comments' ]

  connect() {
    let commentsController = this;
    createChannel({ channel: "CommentsChannel", hn_id: this.data.get("hn-id") }, {
      received({ comments }) {
        commentsController.commentsTarget.innerHTML = comments 
      }
    });
  }
}