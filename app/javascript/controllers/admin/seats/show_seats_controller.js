import { Controller } from "stimulus";
import { fetchWithoutParams } from "../../lib/fetcher";

export default class extends Controller {
  connect() {
    const cinemaId = this.element.dataset.cinemaId;
    const path = `/admin/cinemas/${cinemaId}/seats/index.json`;
    const grid = this.element.firstElementChild;

    fetchWithoutParams(path, "GET")
      .then(({ seatList }) => {
        this.maxRow = seatList.length;
        this.maxColumn = seatList[0].length;

        this.makeSeatingChart(grid, seatList, this.maxRow, this.maxColumn);
      })
      .catch((err) => {
        console.log(err);
      });
  }

  makeSeatingChart(grid, seats, row, column) {
    grid.style.cssText += `grid-template-rows: repeat(${row}, 1fr);grid-template-columns: repeat(${column + 2}, 1fr);`;

    let seatList = "";
    for (let r = 0; r < row; r++) {
      let RowId = `<div class="text-center">${String.fromCharCode(r + 65)}</div>`;
      seatList += RowId;
      for (let c = 0; c < column; c++) {
        let columnId = `<div class="seat-item" data-row-id=${r} data-column-id=${c}>${String(c + 1).padStart(2, "0")}</div>`;

        if (seats[r][c] == 0) {
          columnId = `<div class="seat-item bg-transparent text-dark" data-row-id=${r} data-column-id=${c}>${String(c + 1).padStart(2, "0")}</div>`;
        }
        seatList += columnId;
      }
      seatList += RowId;
    }
    grid.insertAdjacentHTML("beforeend", seatList);
  }
}
