// toggle navbar

const menuToggle = document.getElementById("menu-toggle");

menuToggle.addEventListener("click", function () {
  var navbar = document.getElementById("navbar-default");
  navbar.classList.toggle("hidden");
});

const date = document.getElementById('date')

date.innerText = `${new Date().getFullYear()} Bookit All right reserd` 