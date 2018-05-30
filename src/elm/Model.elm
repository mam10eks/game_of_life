module Model exposing (..)

{-| Model and all possible messages

# Model (i.e. State)
@docs Model

# Msg (i.e. triggers of state changes)
@docs Msg

-}

import Set as Set
import List


{-| The complete state of the application: aka Model ;)
-}
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


{-| All changes within the state (Model) are triggered by Messages.
-}
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
