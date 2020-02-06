import { Elm } from "./Main.elm";

const MutationObserver =
window.MutationObserver ||
window.WebKitMutationObserver ||
window.MozMutationObserver;

const root = document.getElementById("root");
//const root = document.body;

const config = {
  attributes: false,
  childList: true,
  characterData: false,
  subtree: true
};

const observer = new MutationObserver((m, o) => {
  console.log("dom updated");
  app.ports.firstRender.send(true);
  o.disconnect();
  // console.log(m);
});

observer.observe(root, config);

var app = Elm.Main.init({
  node: document.getElementById("entry"),
  flags: 8
});
