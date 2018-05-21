module Model exposing (..)

import Set as Set


type alias Model =
    { width : Int
    , height : Int
    , livingCells : Set.Set ( Int, Int )
    , hoveredCell : ( Int, Int )
    , history : List (Set.Set ( Int, Int ))
    }


type Msg
    = ChangeWidth Int
    | ChangeHeight Int
    | ChangeCell ( Int, Int )
    | HoverCell ( Int, Int )
    | CalculateNextGeneration
    | GoToLastState
    | Clear
