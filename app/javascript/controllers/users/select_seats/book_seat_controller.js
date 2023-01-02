import { Controller } from "stimulus";
import { fetchWithParams } from "../../lib/fetcher";
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
        seat.classList.add("bg-danger", "text-white");
        seat.dataset.status = "reserved";
        delete seat.dataset.action;
      } else {
        seat.classList.remove("bg-success", "bg-danger", "text-white");
        seat.dataset.status = "vacancy";
        seat.dataset.action = "click->users--select-seats--book-seat#changeSeatStatus";
      }
    }
  }

  changeSeatStatus(el) {
    const rowId = +el.target.dataset.rowId;
    const columnId = +el.target.dataset.columnId;
    const seat = el.target;
    const seatStatus = seat.dataset.status;

    switch (seatStatus) {
      case "vacancy":
        this.bookSeat(seat, rowId, columnId);

        break;
      case "reserved":
        this.cancelSeat(seat, rowId, columnId);

        break;
      default:
        console.log("We don't have the seat status");
    }
  }

  bookSeat(seat, row, column) {
    const path = "/tickets";
    const params = { showtime_id: this.showtimeId, row: row, column: column };

    fetchWithParams(path, "POST", params)
      .then(({ msg }) => {
        if (msg == "success") {
          seat.classList.add("bg-success", "text-white");
          seat.dataset.status = "reserved";
        } else {
          seat.classList.add("bg-danger", "text-white");
          seat.dataset.status = "reserved";
          delete seat.dataset.action;
        }
      })
      .catch((err) => {
        console.log(err);
      });
  }

  cancelSeat(seat, row, column) {
    const path = `/tickets`;
    const params = { showtime_id: this.showtimeId, row: row, column: column };

    fetchWithParams(path, "DELETE", params)
      .then(() => {
        seat.classList.remove("bg-success", "bg-danger", "text-white");
        seat.dataset.status = "vacancy";
        seat.dataset.action = "click->users--select-seats--book-seat#changeSeatStatus";
      })
      .catch((err) => {
        console.log(err);
      });
  }
}
