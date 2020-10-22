import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["pageSavedNotice", "savingPageNotice"];

  initialize() {
    if (navigator.serviceWorker) {
      if (navigator.serviceWorker.controller) {
        this.stateChange();
      } else {
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
      navigator.serviceWorker.controller.state,
      " state: ",
      state
    );

    if (state === "activated" || state === "redundant") {
      this.savingPageNoticeTarget.classList.add("is-hidden");
      this.pageSavedNoticeTarget.classList.remove("is-hidden");
    }
  }
}
