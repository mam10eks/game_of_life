module Main exposing (..)

{-| Game of life 

The following points are particularly important:

# Model and messages

[Model.elm](Model.elm) gives an overview about the complete model (i.e. state)
of the application and all messages that could change those state.

# The update method

Determines how the application state (model) will change for a particular message,

# The game of life logic

Is completely implemented within [GameOfLife.elm](GameOfLife.elm).

-}

import Model exposing (..)
import JavascriptPorts as JavascriptPorts
import Util exposing (..)
import Html as Html
import GameOfLife as GameOfLife
import View as View
import Set as Set
import Result as Result


main : Program Flags Model Msg
main =
    Html.programWithFlags { init = init, view = View.view, update = update, subscriptions = \m -> Sub.batch (JavascriptPorts.subscriptions m) }


type alias Flags =
    { width : Int, height : Int, runSpeedInMs : Int }


init : Flags -> ( Model.Model, Cmd Msg )
init flags =
    ( { width = clippedSize flags.width
      , height = clippedSize flags.height
      , runSpeedInMs = clippedRunSpeed flags.runSpeedInMs
      , autoRunEnabled = False
      , livingCells = Set.empty
      , hoveredCell = ( -1, -1 )
      , history = []
      , presentationMode = False,
      pausedBoardState = { width = 0, height = 0, livingCells = Set.empty, history = []}
      }
    , Cmd.none
    )


{-|Apply a message to the current state of the application in order to determine 
the next application state.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( determineModelForNextRound msg model, Cmd.none )


determineModelForNextRound : Msg -> Model -> Model
determineModelForNextRound msg model =
    case msg of
        ChangeWidth newWidth ->
            { model 
              | width = clippedSize newWidth
              , autoRunEnabled = False
              , livingCells = removeCellsOutsideOfGrid model model.livingCells
            }

        ChangeHeight newHeight ->
            { model 
              | height = clippedSize newHeight
              , autoRunEnabled = False
              , livingCells = removeCellsOutsideOfGrid model model.livingCells
            }

        ChangeRunSpeed newSpeed ->
            { model | runSpeedInMs = clippedRunSpeed newSpeed }

        ChangeCell ( a, b ) ->
            { model 
              | livingCells = toggleSetElement ( a, b ) model.livingCells |> removeCellsOutsideOfGrid model 
              , autoRunEnabled = False
            }

        HoverCell ( a, b ) ->
            { model | hoveredCell = ( a, b ) }

        CalculateNextGeneration ->
            let
                ret =
                    { model 
                      | livingCells = GameOfLife.determineNextGeneration model
                      , history = model.livingCells :: model.history 
                    }
            in
                {ret | autoRunEnabled = ret.autoRunEnabled && isRunButtonClickable ret}

        GoToLastState ->
            { model
              | livingCells = List.head model.history |> Maybe.withDefault Set.empty
              , history = List.tail model.history |> Maybe.withDefault []
              , autoRunEnabled = False
            }

        Clear ->
            { model 
              | livingCells = Set.empty
              , history = []
              , autoRunEnabled = False
            }

        EnableAutoRun autoRun ->
            { model | autoRunEnabled = autoRun && isRunButtonClickable model}

        EnablePresentationMode enablePresentationMode ->
            let
                pausedBoardState = 
                    if enablePresentationMode then
                        { width = model.width, height = model.height, livingCells = model.livingCells, history = model.history}
                    else
                        { width = 0, height = 0, livingCells = Set.empty, history = []}
            in
                { model |
                    width = if enablePresentationMode then 5 else model.pausedBoardState.width
                    , height = if enablePresentationMode then 5 else model.pausedBoardState.height
                    , livingCells = if enablePresentationMode then Set.empty else model.pausedBoardState.livingCells
                    , history = if enablePresentationMode then [] else model.pausedBoardState.history
                    , presentationMode = enablePresentationMode
                    , pausedBoardState = pausedBoardState
                    , autoRunEnabled = False
                }

        LoadPattern livingCells ->
            { model
              | livingCells = (Set.fromList livingCells)
              , history = []
              , autoRunEnabled = False
            }