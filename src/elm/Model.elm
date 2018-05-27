module Model exposing (..)

import Set as Set
import List


type alias Model =
    { width : Int
    , height : Int
    , runSpeedInMs : Int
    , livingCells : Set.Set ( Int, Int )
    , hoveredCell : ( Int, Int )
    , history : List (Set.Set ( Int, Int ))
    , presentationMode : Bool
    , autoRunEnabled : Bool
    , pausedBoardState :
        {
            width : Int
            , height : Int
            , livingCells: Set.Set ( Int, Int )
            ,history : List (Set.Set ( Int, Int ))
        }
    }


type Msg
    = ChangeWidth Int
    | ChangeHeight Int
    | ChangeRunSpeed Int
    | ChangeCell ( Int, Int )
    | HoverCell ( Int, Int )
    | CalculateNextGeneration
    | GoToLastState
    | Clear
    | EnablePresentationMode Bool
    | EnableAutoRun Bool
    | LoadPattern (List (Int, Int))
