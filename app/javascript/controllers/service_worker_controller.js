import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["pageSavedNotice", "savingPageNotice"];

  connect() {
    if (navigator.serviceWorker) {
      if (navigator.serviceWorker.controller) {
        // If the service worker is already running, skip to state change
        this.stateChange();
      } else {
        // Register the service worker, and wait for it to become active
        navigator.serviceWorker
          .register("/service-worker.js", { scope: "./" })
          .then(function (reg) {
            console.log("[Companion]", "Service worker registered!");
            console.log(reg);
          });
        navigator.serviceWorker.addEventListener(
          "controllerchange",
          this.controllerChange.bind(this)
        );
      }
    }
  }

  controllerChange(event) {
    console.log(
      '[controllerchange] A "controllerchange" event has happened ' +
        "within navigator.serviceWorker: ",
      event
    );
    navigator.serviceWorker.controller.addEventListener(
      "statechange",
      this.stateChange.bind(this)
    );
  }

  stateChange() {
    let state = navigator.serviceWorker.controller.state;
    console.log(
      "[controllerchange][statechange] " + 'A "statechange" has occured: ',
      state
    );

    if (state === "activated" || state === "redundant") {
      this.savingPageNoticeTarget.classList.add("is-hidden");
      this.pageSavedNoticeTarget.classList.remove("is-hidden");
    }
  }
}
