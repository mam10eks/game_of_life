import Cookie from 'js-cookie'
import Elm from './generated/elm/main.js'
import JQuery from 'jquery'
window.$ = window.jQuery = JQuery;

require('bootstrap')
const Slider = require('bootstrap-slider')

const HIDE_DESCRIPTION_COOKIE_NAME = 'hideDescription';

function changeCollapseState() {
	let toggleDescriptionButton = $("#toggleDescriptionButton");
	toggleDescriptionButton.toggleClass("glyphicon-chevron-up").toggleClass("glyphicon-chevron-down");

	if(toggleDescriptionButton[0].classList.contains("glyphicon-chevron-down")) {
		Cookie.set(HIDE_DESCRIPTION_COOKIE_NAME, 1);
	}
	else {
		Cookie.remove(HIDE_DESCRIPTION_COOKIE_NAME);
	}
}


new Slider('#width', {});
new Slider('#height', {});

let elmMainModule = Elm.Main.embed(document.getElementById("main"));

document.getElementById("height").onchange = () => elmMainModule.ports.changeHeight.send(parseInt(document.getElementById('height').value));
document.getElementById("width").onchange = () => elmMainModule.ports.changeWidth.send(parseInt(document.getElementById('width').value));
document.getElementById("toggleDescriptionButton").onclick = changeCollapseState



if(typeof Cookie.get(HIDE_DESCRIPTION_COOKIE_NAME) === 'undefined') {
	$("#description").collapse('show');
}
else {
	changeCollapseState();
}
