import introJs from 'intro.js'
import 'intro.js/introjs.css'

const steps = [ {
        intro: "Welcome&nbsp;to&nbsp;<b>Conway's&nbsp;Game&nbsp;of&nbsp;Life</b>.<br><br><div style='font-size: 0.8em;'>Where&nbsp;<b>evolution</b>&nbsp;becomes&nbsp;a&nbsp;<b>turn&#8209;based</b>&nbsp;game&nbsp;:)<img src='https://i.ytimg.com/vi/d2AgV_6HkDI/maxresdefault.jpg' width='100%'></div>"
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
        element: "#cell_1_1",
        intro: "A red cell is living"
    }, {
        element: "#cell_2_2",
        intro: "A white cell is dead"
    }, {
        element: "#history_right",
        position: "left",
        intro: "Alright!<br><br><div style='font-size: 0.8em;'>Lets investigate the next <b>round</b> of <b>evolution</b>.</div>"
    }, {
        element: "#cell_2_2",
        intro: "This cell was just born.<br><br><div style='font-size: 0.8em;'>But... all other cells...</div><b>died</b>??"
    }, {
        intro: "Yeah! Thats true.<br><br><div style='font-size: 0.8em;'>Since the game is following two simple rules:<ul><li>A&nbsp;<b>living&nbsp;cell</b>&nbsp;with&nbsp;less&nbsp;then&nbsp;two&nbsp;or&nbsp;more&nbsp;than&nbsp;three&nbsp;living&nbsp;neighbours&nbsp;<b>dies</b></li><li>A <b>dead cell</b> with three living neighbours comes <b>alive</b></li></ul><div>"
    }, {
        element: "#runButton",
        intro: "Now <b>Have Fun!</b><br><br><div style='font-size: 0.8em;'>But try to check out the <b>auto play</b> Feature ;)</div>"
    }
];

const INTRO_OPTIONS = {
    steps: steps,
    showProgress: true,
    showBullets: false,
    skipLabel: "X",
    doneLabel: "X",
    prevLabel: "<-",
    nextLabel: "->"
};

export default class Introduction {
    constructor(detailsView, configurationView, elmMainModule) {
        this.detailsView = detailsView;
        this.configurationView = configurationView;
        this.elmMainModule = elmMainModule;
    }

    onBeforeIntroductionChage(targetElement) {
        if([0, 2].includes(this.intro._currentStep)) {
            this.detailsView.showDetails(false);
        }
        else if([3, steps.length -1].includes(this.intro._currentStep)) {
            this.detailsView.hideDetails(false);
        }
        
        if(3 === this.intro._currentStep) {
            this.clearGameFieldForTutorial();
        }
        else if([4, 6].includes(this.intro._currentStep)) {
            this.firstTutorialBoardExample();
        }
        else if([7, steps.length -1].includes(this.intro._currentStep)) {
            this.finalTutorialBoard();
        }
    }

    initialTutorialBoard() {
        this.setCellClass(1, 1, "cell");
        this.setCellClass(2, 2, "cell");
        this.setCellClass(3, 1, "cell");
        this.setCellClass(2, 3, "cell");
        document.querySelector("#history_right").classList.remove("glyphicon-chevron-right", "myButton")
    }

    firstTutorialBoardExample() {
        this.setCellClass(1, 1, "livingCell");
        this.setCellClass(2, 2, "cell");
        this.setCellClass(3, 1, "livingCell");
        this.setCellClass(2, 3, "livingCell");
        document.querySelector("#history_right").classList.add("glyphicon-chevron-right", "myButton")
    }

    finalTutorialBoard() {
        this.setCellClass(1, 1, "cell");
        this.setCellClass(2, 2, "livingCell");
        this.setCellClass(3, 1, "cell");
        this.setCellClass(2, 3, "cell");
        document.querySelector("#history_right").classList.remove("glyphicon-chevron-right", "myButton")
    }
    
    setCellClass(x, y, clazz) {
        let element = document.querySelector("#cell_"+ x +"_"+ y);
        
        if(element !== null) {
            element.className=clazz;
        }
        else {
            console.log("Couldnt find element #cell_"+ x +"_"+ y)
        }
    }

    onExitTutorial() {
        this.clearGameFieldForTutorial();
        this.configurationView.setWidth(20);
        this.configurationView.setHeight(20);
        this.elmMainModule.ports.enablePresentationMode.send(false);
    }

    clearGameFieldForTutorial() {
        this.configurationView.setWidth(5);
        this.configurationView.setHeight(5);
        this.initialTutorialBoard();
    }

    showTutorial() {
        this.elmMainModule.ports.enablePresentationMode.send(true);
        this.clearGameFieldForTutorial();

        this.intro = introJs();
        this.intro.setOptions(INTRO_OPTIONS);
        this.intro.onbeforechange(()=> this.onBeforeIntroductionChage.call(this));
        this.intro.onexit(() => this.onExitTutorial.call(this));
        this.intro.oncomplete(() => this.onExitTutorial.call(this));
        this.intro.start();
    }
}
