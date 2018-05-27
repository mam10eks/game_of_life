port module JavascriptPorts exposing (subscriptions, nextAutoRunStep)

import Model exposing (..)
import Util exposing (..)
import Time


port changeWidth : (Int -> msg) -> Sub msg


port changeHeight : (Int -> msg) -> Sub msg


port changeSpeed : (Int -> msg) -> Sub msg


port enablePresentationMode : (Bool -> msg) -> Sub msg


port loadPattern : ((List (Int, Int)) -> msg) -> Sub msg


nextAutoRunStep _ = CalculateNextGeneration


subscriptions : Model -> List (Sub Msg)
subscriptions model =
    [ changeWidth ChangeWidth
    , changeHeight ChangeHeight
    , enablePresentationMode EnablePresentationMode
    , loadPattern LoadPattern
    , changeSpeed ChangeRunSpeed ] ++ (runSubscription model)


runSubscription : Model -> List (Sub Msg)
runSubscription model = 
    if model.autoRunEnabled && isRunButtonClickable model then
        [Time.every ((toFloat model.runSpeedInMs) * Time.millisecond) nextAutoRunStep]
    else
        []
