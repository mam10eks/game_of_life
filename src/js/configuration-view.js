import JQuery from 'jquery'
window.$ = window.jQuery = JQuery;

require('bootstrap')
import Slider  from 'bootstrap-slider'

require('bootstrap-slider/dist/css/bootstrap-slider.min.css')
import {clipDimensionSize} from './cookie-storage.js'

const CONFIG_WIDTH_DIMENSION_NAME = "width";
const CONFIG_HEIGHT_DIMENSION_NAME = "height";

class ConfigurationView {
    constructor(onDimensionChanged, conf) {
        this.widthSlider = new Slider('#'+ CONFIG_WIDTH_DIMENSION_NAME, {});
        this.heightSlider = new Slider('#'+ CONFIG_HEIGHT_DIMENSION_NAME, {});

        document.getElementById(CONFIG_HEIGHT_DIMENSION_NAME).onchange = onDimensionChanged;
        document.getElementById(CONFIG_WIDTH_DIMENSION_NAME).onchange = onDimensionChanged;
        this.onDimensionChanged = onDimensionChanged;

        this.widthSlider.setValue(conf.width)
        this.heightSlider.setValue(conf.height)
    }

    getWidth() {
        return this.widthSlider.getValue();
    }

    setWidth(width) {
        this.widthSlider.setValue(clipDimensionSize(width));
        this.onDimensionChanged();
    }

    getHeight() {
        return this.heightSlider.getValue();
    }

    setHeight(height) {
        this.heightSlider.setValue(clipDimensionSize(height));
        this.onDimensionChanged();
    }
}

export {
    ConfigurationView, 
    CONFIG_WIDTH_DIMENSION_NAME,
    CONFIG_HEIGHT_DIMENSION_NAME
};