import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  connect() {
    this.showtimeId = this.element.parentElement.getAttribute("data-showtime-id");
    this.userId = this.element.parentElement.getAttribute("data-user-id");

    this.subscription = consumer.subscriptions.create(
      {
        channel: "SelectSeatsChannel",
        showtime_id: this.showtimeId,
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }

  _connected() {
    console.log("Congratulations ! Connected the channel !");
  }

  _disconnected() {
    console.log("See you !");
  }

  _received(data) {
    const userId = data["userId"];
    const rowId = data["row"];
    const columnId = data["column"];
    const status = data["status"];

    const seat = document.querySelector(`[data-row-id="${rowId}"][data-column-id="${columnId}"]`);
    this.updateSeat(seat, status, userId);
  }

  updateSeat(seat, status, userId) {
    if (userId != this.userId) {
      if (status == "reserved") {
        seat.classList.add("bg-MediumPurple", "text-white");
        seat.dataset.status = "reserved";
        delete seat.dataset.action;
      } else {
        seat.classList.remove("bg-MediumPurple", "text-white");
        seat.dataset.status = "vacancy";
        seat.dataset.action = "click->select-seats--book-seat#changeSeatStatus";
      }
    }
  }
}
