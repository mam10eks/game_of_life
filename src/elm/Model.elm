module Model exposing (..)

import Set as Set
import List


type alias Model =
    { width : Int
    , height : Int
    , livingCells : Set.Set ( Int, Int )
    , hoveredCell : ( Int, Int )
    , history : List (Set.Set ( Int, Int ))
    , presentationMode : Bool
    }


type Msg
    = ChangeWidth Int
    | ChangeHeight Int
    | ChangeCell ( Int, Int )
    | HoverCell ( Int, Int )
    | CalculateNextGeneration
    | GoToLastState
    | Clear
    | EnablePresentationMode Bool
    | LoadPattern (List (Int, Int))
