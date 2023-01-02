import { Controller } from "stimulus";
import { fetchWithoutParams, fetchWithParamsAndRedirect } from "../../lib/fetcher";

export default class extends Controller {
  connect() {
    this.cinemaId = this.element.dataset.cinemaId;
    const path = `/admin/cinemas/${this.cinemaId}/seats/new.json`;
    const grid = this.element.firstElementChild;

    fetchWithoutParams(path, "GET")
      .then(({ seatList }) => {
        this.seatList = seatList;

        this.maxRow = seatList.length;
        this.maxColumn = seatList[0].length;

        this.makeSeatingChart(grid, this.maxRow, this.maxColumn);
      })
      .catch((err) => {
        console.log(err);
      });
  }

  makeSeatingChart(grid, row, column) {
    grid.style.cssText += `grid-template-rows: repeat(${row}, 1fr);grid-template-columns: repeat(${column + 2}, 1fr);`;

    let seatItems = "";
    for (let r = 0; r < row; r++) {
      let RowId = `<div class="text-center">${String.fromCharCode(r + 65)}</div>`;
      seatItems += RowId;
      for (let c = 0; c < column; c++) {
        let columnId = `<div class="seat-item" data-row-id=${r} data-column-id=${c} data-status="added" data-action="click->admin--seats--create-seats#changeSeatStatus">${String(c + 1).padStart(2, "0")}</div>`;

        seatItems += columnId;
      }
      seatItems += RowId;
    }
    grid.insertAdjacentHTML("beforeend", seatItems);
  }

  changeSeatStatus(el) {
    const rowId = +el.target.dataset.rowId;
    const columnId = +el.target.dataset.columnId;
    let seatStatus = el.target.dataset.status;

    switch (seatStatus) {
      case "not added":
        el.target.classList.remove("bg-transparent", "text-dark");

        el.target.dataset.status = "added";

        this.seatList[rowId][columnId] = 1;
        break;
      case "added":
        el.target.classList.add("bg-transparent", "text-dark");

        el.target.dataset.status = "not added";

        this.seatList[rowId][columnId] = 0;
        break;
      default:
        console.log("We don't have the seat status");
    }
  }

  createToTable() {
    const path = `/admin/cinemas/${this.cinemaId}/seats`;
    const seats = { seat_list: this.seatList };

    fetchWithParamsAndRedirect(path, "POST", seats).catch((err) => {
      console.log(err);
    });
  }
}
