import createChannel from "cables/cable";

const topNews = createChannel("TopNewsChannel", {
  received({ message }) {
    console.log("received data")
    console.log(message)
  }
});

console.log("top_news_channel.js")
console.log(topNews)