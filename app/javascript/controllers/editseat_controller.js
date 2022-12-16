import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.maxRow = this.element.dataset.maxrow;
    this.maxColumn = this.element.dataset.maxcolumn;
    this.seatsNotAddedStr = this.element.dataset.notAdded

    this.seatsNotAdded = this.seatsNotAddedStr .substring(1, this.seatsNotAddedStr.length-1).split(", ").map((s)=>{
      return parseInt(s.substring(1, s.length-1));
    });
    this.seatsAll = [...Array(this.maxRow * this.maxColumn).keys()].map(x => x + 1);

    this.makeSeatingChart(this.maxRow, this.maxColumn);
  }

  makeSeatingChart(maxR, maxC) {
    const grid = this.element.firstElementChild;

    grid.style.cssText += `grid-template-rows: repeat(${maxR}, 1fr);grid-template-columns: repeat(${maxC}, 1fr);`;
    
    for (var r = 1; r <= maxR; r++) {
      let row_index = String.fromCharCode(r + 64);
      for (let c = 1; c <= maxC; c++) {
        let seatIdStr = (r-1)*maxC + c;

        let item = `<div class="seat-item" data-seat-id=${(r-1)*maxC + c} data-status="added" data-action="click->editseat#changeSeatStatus">${row_index}${String(c).padStart(2, '0')}</div>`;
        if (this.seatsNotAdded.includes(seatIdStr)) {
          item = `<div class="seat-item bg-transparent" data-seat-id=${(r-1)*maxC + c} data-status="not added" data-action="click->editseat#changeSeatStatus">${row_index}${String(c).padStart(2, '0')}</div>`;
        }

        grid.insertAdjacentHTML("beforeend", item);      
      }
    }
  }

  changeSeatStatus(el) {
    const seatId = +el.target.dataset.seatId;
    let seatStatus = el.target.dataset.status;

    switch (seatStatus) {
      case "not added":
        el.target.classList.remove("bg-transparent")

        el.target.dataset.status = "added";

        const index = this.seatsNotAdded.indexOf(seatId);
        this.seatsNotAdded.splice(index, 1);
        break;
      case "added":
        el.target.classList.add("bg-transparent");

        el.target.dataset.status = "not added";

        this.seatsNotAdded.push(seatId);
        break;
      default:
        console.log("We don't have the seat status");
    }        
  }

  updateToTable() {
    const token = document.querySelector("meta[name='csrf-token']").content;
    const cinemaId = this.element.dataset.id;

    this.seatsAdded = this.seatsAll.filter(s => !this.seatsNotAdded.includes(s));
    const seats = {"added": this.seatsAdded, "notAdded": this.seatsNotAdded}

    fetch(`/admin/cinemas/${cinemaId}/seats/update`, {
      method: "PATCH",
      headers: {
        "X-csrf-Token": token,
        "Content-Type": "application/json"
      },
      redirect: 'follow',
      body: JSON.stringify(seats)
    })
    .then((resp) => {
      if (resp.redirected) {
        window.location.href = resp.url;
      }
    })
    .catch((err) => {
      console.log(err);
    });
  }
}