import { Controller } from "stimulus";
import { fetchWithoutParams } from "./lib/fetcher";

export default class extends Controller {
  static targets = ["cancelBtn", "orderStatus"];

  connect() {
    this.setOrderState(this.element.dataset.canceled === "canceled");
  }

  cancel() {
    const orderId = this.element.dataset.id;
    const path = `/orders/${orderId}.json`;

    fetchWithoutParams(path, "DELETE")
      .then(({ status }) => {
        this.setOrderState(status === "canceled");
        this.orderStatusTarget.textContent = "已取消";
      })
      .catch((err) => {
        console.log(err);
      });
  }

  setOrderState(state) {
    if (state) {
      this.cancelBtnTarget.classList.add("disabled");
    }
  }
}
