import { Controller } from "stimulus";
import { fetchWithParams } from "../../lib/fetcher";

export default class extends Controller {
  connect() {
    const cinemaId = this.element.dataset.cinemaId;
    const showtimeId = this.element.dataset.showtimeId;

    const path = `/seats/index`;
    const params = { cinema_id: cinemaId, showtime_id: showtimeId };

    const grid = this.element.firstElementChild;

    fetchWithParams(path, "POST", params)
      .then(({ seatList }) => {
        const maxRow = seatList.length;
        const maxColumn = seatList[0].length;
        this.makeSeatingChart(grid, seatList, maxRow, maxColumn);
      })
      .catch((err) => {
        console.log(err);
      });
  }

  makeSeatingChart(grid, seats, row, column) {
    grid.style.cssText += `grid-template-rows: repeat(${row}, 1fr);grid-template-columns: repeat(${column + 2}, 1fr);`;

    let seatList = "";
    for (let r = 0; r < row; r++) {
      let RowId = `<div class="item item-alphabet mx-3">${String.fromCharCode(r + 65)}</div>`;
      seatList += RowId;
      for (let c = 0; c < column; c++) {
        let columnId = this.makeSeat(seats[r][c], r, c);
        seatList += columnId;
      }
      seatList += RowId;
    }
    grid.insertAdjacentHTML("beforeend", seatList);
  }

  makeSeat(status, row, column) {
    let columnId = `<div class="item" data-row-id=${row} data-column-id=${column} data-status="vacancy" data-action="click->users--select-seats--book-seat#changeSeatStatus">${String(column + 1).padStart(2, "0")}</div>`;

    if (status == 0) {
      columnId = `<div class="item item-hidden" data-row-id=${row} data-column-id=${column}>${String(column + 1).padStart(2, "0")}</div>`;
    } else if (status == 2) {
      columnId = `<div class="item bg-secondary text-white" data-row-id=${row} data-column-id=${column} data-status="booked">${String(column + 1).padStart(2, "0")}</div>`;
    } else if (status == 3) {
      columnId = `<div class="item bg-success text-white" data-row-id=${row} data-column-id=${column} data-status="reserved" data-action="click->users--select-seats--book-seat#changeSeatStatus">${String(column + 1).padStart(2, "0")}</div>`;
    } else if (status == 4) {
      columnId = `<div class="item bg-danger text-white" data-row-id=${row} data-column-id=${column} data-status="reserved">${String(column + 1).padStart(2, "0")}</div>`;
    }

    return columnId;
  }
}
