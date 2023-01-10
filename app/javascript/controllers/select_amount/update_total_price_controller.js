import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["price"];

  connect() {
    this.priceArr = [0, 0, 0, 0];
  }

  update({ detail }) {
    const type = detail.type;

    if (type === "regular") {
      this.priceArr[0] = detail.price;
    } else if (type === "concession") {
      this.priceArr[1] = detail.price;
    } else if (type === "elderly") {
      this.priceArr[2] = detail.price;
    } else {
      this.priceArr[3] = detail.price;
    }

    this.priceTarget.textContent = this.priceArr.reduce((a, b) => a + b, 0);
  }
}
