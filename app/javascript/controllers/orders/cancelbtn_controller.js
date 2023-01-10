import { Controller } from "stimulus";
import { fetchWithoutParams } from "../lib/fetcher";

export default class extends Controller {
  static targets = ["cancelBtn", "orderStatus"];

  connect() {
    this.setOrderState(this.element.dataset.status);
  }

  cancel() {
    const orderId = this.element.dataset.id;
    const path = `/orders/${orderId}.json`;

    fetchWithoutParams(path, "DELETE")
      .then(({ status }) => {
        this.setOrderState(status);
        this.orderStatusTarget.textContent = "已取消";

        var event = new CustomEvent("cancel", {});
        window.dispatchEvent(event);
      })
      .catch((err) => {
        console.log(err);
      });
  }

  setOrderState(state) {
    if (state === "canceled") {
      this.cancelBtnTarget.classList.add("disabled");
    }
  }
}
