import JQuery from 'jquery'
window.$ = window.jQuery = JQuery;

require('bootstrap')
import Slider  from 'bootstrap-slider'

require('bootstrap-slider/dist/css/bootstrap-slider.min.css')
import {clipDimensionSize, clipSpeed} from './cookie-storage.js'

const CONFIG_WIDTH_DIMENSION_NAME = 'width';
const CONFIG_HEIGHT_DIMENSION_NAME = 'height';
const CONFIG_SPEED_NAME = 'speed';

class ConfigurationView {
    constructor(onDimensionChanged, onChangeSpeed, conf) {
        this.widthSlider = new Slider('#'+ CONFIG_WIDTH_DIMENSION_NAME, {});
        this.heightSlider = new Slider('#'+ CONFIG_HEIGHT_DIMENSION_NAME, {});
        this.speedSlider = new Slider('#'+ CONFIG_SPEED_NAME, {});

        document.getElementById(CONFIG_HEIGHT_DIMENSION_NAME).onchange = onDimensionChanged;
        document.getElementById(CONFIG_WIDTH_DIMENSION_NAME).onchange = onDimensionChanged;
        document.getElementById(CONFIG_SPEED_NAME).onchange = onChangeSpeed;
        this.onDimensionChanged = onDimensionChanged;
        this.onChangeSpeed = onChangeSpeed;

        this.widthSlider.setValue(conf.width);
        this.heightSlider.setValue(conf.height);
        this.speedSlider.setValue(conf.speed);
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

    getSpeed() {
        return this.speedSlider.getValue();
    }

    setSpeed(speed) {
        this.speedSlider.setValue(clipSpeed(conf.speed));
        this.onChangeSpeed();
    }
}

export {
    ConfigurationView, 
    CONFIG_WIDTH_DIMENSION_NAME,
    CONFIG_HEIGHT_DIMENSION_NAME,
    CONFIG_SPEED_NAME
};