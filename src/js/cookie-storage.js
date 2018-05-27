import Cookie from 'js-cookie'

import {CONFIG_WIDTH_DIMENSION_NAME, CONFIG_HEIGHT_DIMENSION_NAME, CONFIG_SPEED_NAME} from './configuration-view.js'

const MINIMUM_DIMENSION = 4;

const MAXIMUM_DIMENSION = 20;

const MINIMUM_SPEED = 50;

const MAXIMUM_SPEED = 2000;

const HIDE_DESCRIPTION_COOKIE_NAME = 'hideDescription';

const USER_HAS_SEEN_TUTORIAL = 'userHasSeenTutorial';

function getDimensionValueFromCookie(dimensionName) {
	return clipDimensionSize(parseInt(Cookie.get(dimensionName)));
}

function clipDimensionSize(dimensionSize) {
    dimensionSize = Number.isInteger(dimensionSize) ? dimensionSize : MINIMUM_DIMENSION;
    return Math.max(Math.min(MAXIMUM_DIMENSION, dimensionSize), MINIMUM_DIMENSION);
}

function clipSpeed(speed) {
    speed = Number.isInteger(speed) ? speed : MINIMUM_SPEED;
    return Math.max(Math.min(MAXIMUM_SPEED, speed), MINIMUM_SPEED);
}

class CookieStorage {
    getWidth() {
        return getDimensionValueFromCookie(CONFIG_WIDTH_DIMENSION_NAME);
    }

    setWidth(width) {
	    Cookie.set(CONFIG_WIDTH_DIMENSION_NAME, width);
    }

    getHeight() {
        return getDimensionValueFromCookie(CONFIG_HEIGHT_DIMENSION_NAME);
    }

    setHeight(height) {
	    Cookie.set(CONFIG_HEIGHT_DIMENSION_NAME, height);
    }

    getSpeed() {
        return clipSpeed(parseInt(Cookie.get(CONFIG_SPEED_NAME)));
    }

    setSpeed(speed) {
        Cookie.set(CONFIG_SPEED_NAME, speed);
    }

    hideDetails() {
        Cookie.set(HIDE_DESCRIPTION_COOKIE_NAME, 1);
    }

    showDetails() {
        Cookie.remove(HIDE_DESCRIPTION_COOKIE_NAME);
    }

    userShouldStartTutorial() {
        return typeof Cookie.get(USER_HAS_SEEN_TUTORIAL) === 'undefined';
    } 

    setUserHasSeenTutorial() {
        Cookie.set(USER_HAS_SEEN_TUTORIAL, 1);
    }

    areDetailsHidden() {
        return typeof Cookie.get(HIDE_DESCRIPTION_COOKIE_NAME) !== 'undefined';
    }
}

export { CookieStorage, clipDimensionSize, clipSpeed }