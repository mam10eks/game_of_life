export default class DetailsView {
    constructor(onHideDetails, onShowDetails) {
        this.onHideDetails = onHideDetails;
        this.onShowDetails = onShowDetails;

        document.getElementById("toggleDescriptionButton").onclick = () => this.toggleState();
    }

    hideDetails(useTransition=true) {
        let toggleDescriptionButton = $("#toggleDescriptionButton");
        toggleDescriptionButton[0].classList.toggle("glyphicon-chevron-up", false);
        toggleDescriptionButton[0].classList.toggle("glyphicon-chevron-down", true);

        let descriptionElement = $("#description");
        
        if(useTransition) {
            descriptionElement.collapse('hide');
        }
        else {
            descriptionElement[0].classList.toggle("in", false);
        }

        this.onHideDetails();
    }

    showDetails(useTransition=true) {
        let toggleDescriptionButton = $("#toggleDescriptionButton");
        toggleDescriptionButton[0].classList.toggle("glyphicon-chevron-up", true);
        toggleDescriptionButton[0].classList.toggle("glyphicon-chevron-down", false);

        let descriptionElement = $("#description");
        
        if(useTransition) {
            descriptionElement.collapse('show');
        }
        else {
            descriptionElement[0].classList.toggle("in", true);
        }

        this.onShowDetails();
    }

    toggleState() {
        let toggleDescriptionButton = $("#toggleDescriptionButton");

        if(toggleDescriptionButton[0].classList.contains("glyphicon-chevron-down")) {
            this.showDetails();
        }
        else {
            this.hideDetails();
        }
    }
}