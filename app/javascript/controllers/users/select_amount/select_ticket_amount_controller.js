import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["Amount", "Price", "Subtotal"];

  select() {
    const price = +this.PriceTarget.textContent;
    const amount = +this.AmountTarget.value;
    this.SubtotalTarget.textContent = price * amount;

    var event = new CustomEvent("totalAdd", {
      detail: {
        type: this.element.dataset.ticketType,
        amount: amount,
        price: price * amount,
      },
    });
    window.dispatchEvent(event);
  }
}
