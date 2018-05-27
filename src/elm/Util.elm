module Util exposing (..)

import Model exposing (..)
import Set as Set


isRunButtonClickable : Model -> Bool
isRunButtonClickable model = not (Set.isEmpty model.livingCells)


isCleanButtonClickable : Model -> Bool
isCleanButtonClickable model = isRunButtonClickable model || not (List.isEmpty model.history)


clippedSize : Int -> Int
clippedSize size =
    max (min size 20) 4


clippedRunSpeed : Int -> Int
clippedRunSpeed speed =
    max (min speed 2000) 50


toggleSetElement : comparable -> Set.Set comparable -> Set.Set comparable
toggleSetElement elem set =
    if Set.member elem set then
        Set.remove elem set
    else
        Set.insert elem set


removeCellsOutsideOfGrid : Model -> Set.Set ( Int, Int ) -> Set.Set ( Int, Int )
removeCellsOutsideOfGrid model set =
    Set.filter (\( a, b ) -> a < model.height && b < model.width) set
