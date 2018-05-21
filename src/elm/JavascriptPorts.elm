port module JavascriptPorts exposing (subscriptions)

import Model exposing (..)


port changeWidth : (Int -> msg) -> Sub msg


port changeHeight : (Int -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ changeWidth ChangeWidth, changeHeight ChangeHeight ]
