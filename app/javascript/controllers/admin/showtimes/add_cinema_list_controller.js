import { Controller } from "stimulus";
import { fetchWithParams } from "../../lib/fetcher";
import { resetOptions } from "../../lib/reset_dropdown_options";

export default class extends Controller {
  static targets = ["theater", "cinemaList"];

  addCinemaList(el) {
    resetOptions(this.cinemaListTarget, "請選擇影廳", false);

    this.theaterId = el.target.value;
    fetchWithParams("/api/v1/cinema_list", "POST", {
      theater_id: this.theaterId,
    })
      .then((data) => {
        let options = "";

        data.forEach((element) => {
          options += `<option class="form-control mr-sm-2" value="${element.id}" >${element.name}</option>`;
        });

        this.cinemaListTarget.insertAdjacentHTML("beforeend", options);
      })
      .catch((err) => {
        console.log(err);
      });
  }
}
