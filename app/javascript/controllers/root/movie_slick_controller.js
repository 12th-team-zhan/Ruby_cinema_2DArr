import { Controller } from "stimulus";
import $ from "jquery";
import "slick-carousel";
import "slick-carousel/slick/slick.scss";
import "slick-carousel/slick/slick-theme.scss";

export default class extends Controller {
  connect() {
    console.log(123);
    $(".slider").slick({
      infinite: true,
      slidesToShow: 3,
      slidesToScroll: 3,
    });
  }
}
