module Main exposing (main, update)

{-| The main module for the game of life application.
The documentation of the components is roughly ordered by importance.

# The Update Method
@docs update

# The Main Method
@docs main
-}

import Model exposing (..)
import JavascriptPorts as JavascriptPorts
import View as View
import Html as Html
import GameOfLife as GameOfLife
import Set as Set
import Result as Result

{-| Weave everything together to a program with flags.
-}
main : Program Flags Model Msg
main =
    Html.programWithFlags { init = init, view = View.view, update = update, subscriptions = JavascriptPorts.subscriptions }


type alias Flags =
    { width : Int, height : Int }


init : Flags -> ( Model.Model, Cmd Msg )
init flags =
    ( { width = clippedSize flags.width
      , height = clippedSize flags.height
      , livingCells = Set.empty
      , hoveredCell = ( -1, -1 )
      , history = []
      , presentationMode = False,
      pausedBoardState = { width = 0, height = 0, livingCells = Set.empty, history = []}
      }
    , Cmd.none
    )


clippedSize : Int -> Int
clippedSize size =
    max (min size 20) 4


toggleSetElement : comparable -> Set.Set comparable -> Set.Set comparable
toggleSetElement elem set =
    if Set.member elem set then
        Set.remove elem set
    else
        Set.insert elem set


removeCellsOutsideOfGrid : Model -> Set.Set ( Int, Int ) -> Set.Set ( Int, Int )
removeCellsOutsideOfGrid model set =
    Set.filter (\( a, b ) -> a < model.height && b < model.width) set


{-| Calculate the next model based on a current model and a message.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeWidth newWidth ->
            ( { model | width = clippedSize newWidth, livingCells = removeCellsOutsideOfGrid model model.livingCells }, Cmd.none )

        ChangeHeight newHeight ->
            ( { model | height = clippedSize newHeight, livingCells = removeCellsOutsideOfGrid model model.livingCells }, Cmd.none )

        ChangeCell ( a, b ) ->
            ( { model | livingCells = toggleSetElement ( a, b ) model.livingCells |> removeCellsOutsideOfGrid model }, Cmd.none )

        HoverCell ( a, b ) ->
            ( { model | hoveredCell = ( a, b ) }, Cmd.none )

        CalculateNextGeneration ->
            ( { model | livingCells = GameOfLife.determineNextGeneration model, history = model.livingCells :: model.history }, Cmd.none )

        GoToLastState ->
            ( { model
                | livingCells = List.head model.history |> Maybe.withDefault Set.empty
                , history = List.tail model.history |> Maybe.withDefault []
              }
            , Cmd.none
            )

        Clear ->
            ( { model | livingCells = Set.empty, history = [] }, Cmd.none )

        EnablePresentationMode enablePresentationMode ->
            let
                pausedBoardState = 
                    if enablePresentationMode then
                        { width = model.width, height = model.height, livingCells = model.livingCells, history = model.history}
                    else
                        { width = 0, height = 0, livingCells = Set.empty, history = []}
            in
                ( { model |
                    width = if enablePresentationMode then 5 else model.pausedBoardState.width
                    , height = if enablePresentationMode then 5 else model.pausedBoardState.height
                    , livingCells = if enablePresentationMode then Set.empty else model.pausedBoardState.livingCells
                    , history = if enablePresentationMode then [] else model.pausedBoardState.history
                    , presentationMode = enablePresentationMode
                    , pausedBoardState = pausedBoardState
                  }, Cmd.none )

        LoadPattern livingCells ->
            ( {model | livingCells = (Set.fromList livingCells), history = []}, Cmd.none )
