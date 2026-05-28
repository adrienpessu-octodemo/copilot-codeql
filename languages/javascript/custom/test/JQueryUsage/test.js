// bad
$(document).ready(function () {
  $("button").click(function () {
    $("p").hide();
  });
});

jQuery(document).ready(function () {
  jQuery("div").hide();
});

// good
const id = "button";
document.getElementById(id).addEventListener("click", function () {
  document.querySelectorAll("p").forEach((el) => el.remove());
});
