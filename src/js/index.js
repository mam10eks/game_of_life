import Elm from '../elm/Main'
import {ConfigurationView, CONFIG_WIDTH_DIMENSION_NAME, CONFIG_HEIGHT_DIMENSION_NAME} from './configuration-view.js'
import {CookieStorage} from './cookie-storage.js'
import DetailsView from './details-view.js'
import Introduction from './introduction.js'

import 'bootstrap/dist/css/bootstrap.min.css'
import '../css/style.css'

let cookieStorage = new CookieStorage();

let detailsView = new DetailsView(
	() => cookieStorage.hideDetails(), 
	() => cookieStorage.showDetails()
);

let configurationView = new ConfigurationView(onChangeDimension, {
	width: cookieStorage.getWidth(),
	height: cookieStorage.getHeight()
});

let elmMainModule = Elm.Main.embed(document.getElementById("main"),
	{width: configurationView.getWidth(), height: configurationView.getHeight()});

function onChangeDimension () {
	elmMainModule.ports.changeWidth.send(configurationView.getWidth());
	elmMainModule.ports.changeHeight.send(configurationView.getHeight());

	cookieStorage.setWidth(configurationView.getWidth());
	cookieStorage.setHeight(configurationView.getHeight());
}

if(cookieStorage.areDetailsHidden()) {
	detailsView.hideDetails();
}
else {
	detailsView.showDetails();
}

document.getElementById("loadingContainer").style.display = "none";
document.getElementById("contentContainer").style.display = "inline";

document.getElementById("tutorial").onclick = () => new Introduction(detailsView, configurationView, elmMainModule).showTutorial();

if(cookieStorage.userShouldStartTutorial()) {
	setTimeout(() => {
		cookieStorage.setUserHasSeenTutorial();
		new Introduction(detailsView, configurationView, elmMainModule).showTutorial();
	}, 1);
}

function loadPattern(examplePattern) {
	configurationView.setWidth(examplePattern.width);
	configurationView.setHeight(examplePattern.height);
	elmMainModule.ports.loadPattern.send(examplePattern.pattern);
	$('#examplePatternsLong').modal('hide');
}

export { loadPattern }