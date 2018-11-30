// from https://evilmartians.com/chronicles/evil-front-part-3
import cable from "actioncable";

let consumer;

function createChannel(...args) {
  if (!consumer) {
    consumer = cable.createConsumer();
  }

  return consumer.subscriptions.create(...args);
}

export default createChannel;
