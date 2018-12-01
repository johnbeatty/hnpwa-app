import createChannel from "cables/cable";

const topNews = createChannel("TopNewsChannel", {
  received({ message, top_item_id }) {
    console.log(message)
    console.log(top_item_id)
    let existingItem = document.querySelector(`[data-top-item-id='${ top_item_id }']`)
    if (existingItem) {
      existingItem.replaceWith( `${ message }` )
    }
  }
});
