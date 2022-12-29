import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["amount"];

  connect() {
    this.amountArr = [0, 0, 0, 0];
  }

  update({ detail }) {
    const type = detail.type;

    if (type === "regular") {
      this.amountArr[0] = detail.amount;
    } else if (type === "concession") {
      this.amountArr[1] = detail.amount;
    } else if (type === "elderly") {
      this.amountArr[2] = detail.amount;
    } else {
      this.amountArr[3] = detail.amount;
    }

    const amountSum = this.amountArr.reduce((a, b) => a + b, 0);
    this.amountTarget.textContent = amountSum;

    if (amountSum === 0) {
      this.element.href = "#";
    } else {
      const showtimeId = this.amountTarget.dataset.id;
      const link = new URLSearchParams({
        showtime_id: showtimeId,
        regular_quantity: this.amountArr[0],
        concession_quantity: this.amountArr[1],
        elderly_quantity: this.amountArr[2],
        disability_quantity: this.amountArr[3],
      });
      this.element.href = `/ticketing/select_seats?` + link.toString();
    }
  }
}
