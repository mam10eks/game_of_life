import Cookie from 'js-cookie'
import Elm from './generated/elm/main.js'
import JQuery from 'jquery'
window.$ = window.jQuery = JQuery;

require('bootstrap')
const Slider = require('bootstrap-slider')

const HIDE_DESCRIPTION_COOKIE_NAME = 'hideDescription';
const WIDTH_DIMENSION_COOKIE_NAME = 'width';
const HEIGHT_DIMENSION_COOKIE_NAME = 'height';

const elmDimensionPorts = {
	'width': i => elmMainModule.ports.changeWidth.send(i),
	'height': i => elmMainModule.ports.changeHeight.send(i)
}

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

function onChangeDimension (dimensionName) {
	let dimensionSize = parseInt(document.getElementById(dimensionName).value);

	Cookie.set(dimensionName, dimensionSize);
	elmDimensionPorts[dimensionName](dimensionSize);
}

function getDimensionValueFromCookie(dimensionName) {
	let dimensionSize = Cookie.get(dimensionName);

	return (typeof dimensionSize === 'undefined') ? 4 : dimensionSize;
}

let widthSlider = new Slider('#'+ WIDTH_DIMENSION_COOKIE_NAME, {});
let heightSlider = new Slider('#'+ HEIGHT_DIMENSION_COOKIE_NAME, {});

document.getElementById(HEIGHT_DIMENSION_COOKIE_NAME).onchange = () => onChangeDimension(HEIGHT_DIMENSION_COOKIE_NAME);
document.getElementById(WIDTH_DIMENSION_COOKIE_NAME).onchange = () => onChangeDimension(WIDTH_DIMENSION_COOKIE_NAME);
document.getElementById("toggleDescriptionButton").onclick = changeCollapseState

if(typeof Cookie.get(HIDE_DESCRIPTION_COOKIE_NAME) === 'undefined') {
	$("#description").collapse('show');
}
else {
	changeCollapseState();
}

widthSlider.setValue(getDimensionValueFromCookie(WIDTH_DIMENSION_COOKIE_NAME));
heightSlider.setValue(getDimensionValueFromCookie(HEIGHT_DIMENSION_COOKIE_NAME));

let elmMainModule = Elm.Main.embed(document.getElementById("main"),
	{width: widthSlider.getValue(), height: heightSlider.getValue()});

document.getElementById("loadingContainer").style.display = "none";
document.getElementById("contentContainer").style.display = "inline";
