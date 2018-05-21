module Main exposing (..)

import Model exposing (..)
import JavascriptPorts as JavascriptPorts
import View as View
import Html as Html
import GameOfLife as GameOfLife
import Set as Set
import Result as Result


main =
    Html.program { init = ( model, Cmd.none ), view = View.view, update = update, subscriptions = JavascriptPorts.subscriptions }


model =
    { width = 4, height = 4, livingCells = Set.empty, hoveredCell = ( -1, -1 ), history = [] }


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
