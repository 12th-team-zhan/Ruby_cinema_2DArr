import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    const token = document.querySelector("meta[name='csrf-token']").content;
    const cinemaId = this.element.dataset.cinemaId;

    fetch(`/admin/cinemas/${cinemaId}/seats/index.json`, {
      method: "GET",
      headers: {
        "X-csrf-Token": token,
      },
    })
      .then((resp) => {
        return resp.json();
      })
      .then(({ seatList }) => {
        this.seatList = seatList;

        this.maxRow = this.seatList.length;
        this.maxColumn = this.seatList[0].length;

        this.makeSeatingChart(this.seatList, this.maxRow, this.maxColumn);
      })
      .catch((err) => {
        console.log(err);
      });
  }

  makeSeatingChart(seats, row, column) {
    const grid = this.element.firstElementChild;
    grid.style.cssText += `grid-template-rows: repeat(${row}, 1fr);grid-template-columns: repeat(${column + 2}, 1fr);`;

    let seatList = "";
    for (let r = 0; r < row; r++) {
      let RowId = `<div class="text-center">${String.fromCharCode(r + 65)}</div>`;
      seatList += RowId;
      for (let c = 0; c < column; c++) {
        let columnId = `<div class="seat-item" data-row-id=${r} data-column-id=${c}>${String(c + 1).padStart(2, "0")}</div>`;

        if (seats[r][c] == 0) {
          columnId = `<div class="seat-item bg-transparent" data-row-id=${r} data-column-id=${c}>${String(c + 1).padStart(2, "0")}</div>`;
        }
        seatList += columnId;
      }
      seatList += RowId;
    }
    grid.insertAdjacentHTML("beforeend", seatList);
  }
}
