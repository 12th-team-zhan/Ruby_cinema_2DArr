import { Controller } from "stimulus";
import QRCode from "qrcode";

export default class extends Controller {
  static targets = ["canvas"];

  connect() {
    this.canvasTargets.forEach((el) => {
      QRCode.toCanvas(el, el.dataset.serial, function (error) {
        if (error) console.error(error);
      });
    });
  }
}
