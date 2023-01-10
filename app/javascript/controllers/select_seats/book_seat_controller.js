import { Controller } from "stimulus";
import { fetchWithoutParams, fetchWithParams } from "../lib/fetcher";

export default class extends Controller {
  connect() {
    this.showtimeId = this.element.parentElement.getAttribute("data-showtime-id");
    this.userId = this.element.parentElement.getAttribute("data-user-id");

    const path = "/tickets/records";
    fetchWithoutParams(path, "GET")
      .then(({ totalQuantity, seats }) => {
        this.totalQuantity = totalQuantity;
        this.seats = seats;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  changeSeatStatus(el) {
    const rowId = +el.target.dataset.rowId;
    const columnId = +el.target.dataset.columnId;
    const seat = el.target;
    const seatStatus = seat.dataset.status;

    this.checkSeatStatus(seatStatus, seat, rowId, columnId);

    if (this.seats.length > this.totalQuantity) {
      const rowIdFirst = this.seats[0][0];
      const columnIdFirst = this.seats[0][1];
      const seatFirst = document.querySelector(`[data-row-id="${rowIdFirst}"][data-column-id="${columnIdFirst}"]`);
      const seatStatusFirst = seatFirst.dataset.status;

      this.checkSeatStatus(seatStatusFirst, seatFirst, rowIdFirst, columnIdFirst);
    }
  }

  checkSeatStatus(seatStatus, seat, rowId, columnId) {
    switch (seatStatus) {
      case "vacancy":
        this.bookSeat(seat, rowId, columnId);
        this.seats.push([rowId, columnId]);

        break;
      case "reserved":
        this.cancelSeat(seat, rowId, columnId);

        this.seats = this.seats.filter(function (item) {
          return item[0] != rowId || item[1] != columnId;
        });

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
          seat.classList.add("bg-LightCerulean", "text-white");
          seat.dataset.status = "reserved";
        } else {
          seat.classList.add("bg-MediumPurple", "text-white");
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
        seat.classList.remove("bg-LightCerulean", "text-white");
        seat.dataset.status = "vacancy";
        seat.dataset.action = "click->select-seats--book-seat#changeSeatStatus";
      })
      .catch((err) => {
        console.log(err);
      });
  }
}
