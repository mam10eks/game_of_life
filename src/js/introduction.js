import introJs from 'intro.js'
import 'intro.js/introjs.css'

const steps = [ {
        intro: "Welcome to <b>Conway's Game of Life</b>.<p></p>"
    }, {
        element: "#tutorial",
        position: "right",
        intro: "You could always repeat this introduction." 
    }, {
        element: "#configuration",
        intro: "Or change your preferences"
    }, {
        element: "#toggleDescriptionButton",
        position: "top",
        intro: "And open those informations again."
    }, {
        intro: "A red cell is living"
    }, {
        intro: "A white cell is dead"
    }, {
        intro: "You could navigate manually through the steps."
    }, {
        element: "#runButton",
        intro: "Now <b>Have Fun!</b><br><br>But try to check out the auto play Feature ;)"
    }
];

const intro = introJs.introJs();
intro.setOptions({
    steps: steps,
    showProgress: true,
    showBullets: false,
    skipLabel: "X",
    doneLabel: "X",
    prevLabel: "<-",
    nextLabel: "->"
});

export default class Introduction {
    constructor(detailsView) {
        intro.onbeforechange(function(targetElement) {
            if(intro._currentStep < 3) {
                detailsView.showDetails(false);
            }
            else {
                detailsView.hideDetails(false);
            }
        });
    }

    showTutorial() {
        intro.start();
    }
}
