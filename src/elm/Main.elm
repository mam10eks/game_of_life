port module Main exposing (..)

import Html as Html
import Set as Set
import Html.Attributes as Attributes
import Html.Events as Events
import Result as Result


main =
    Html.program { init = ( model, Cmd.none ), view = view, update = update, subscriptions = subscriptions }


type alias Model =
    { width : Int, height : Int, livingCells : Set.Set ( Int, Int ), hoveredCell : ( Int, Int ), history : List (Set.Set ( Int, Int )) }


model =
    { width = 4, height = 4, livingCells = Set.empty, hoveredCell = ( -1, -1 ), history = [] }


type Msg
    = ChangeWidth Int
    | ChangeHeight Int
    | ChangeCell ( Int, Int )
    | HoverCell ( Int, Int )
    | CalculateNextGeneration
    | GoToLastState


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


livesInNextGeneration : ( Int, Int ) -> Model -> Bool
livesInNextGeneration ( a, b ) model =
    let
        livingNeighbours =
            determineCountOfLivingNeighbours ( a, b ) model
    in
        ((Set.member ( a, b ) model.livingCells) && livingNeighbours == 2) || livingNeighbours == 3


determineCountOfLivingNeighbours : ( Int, Int ) -> Model -> Int
determineCountOfLivingNeighbours ( a, b ) model =
    Set.size (Set.filter (\i -> Set.member i model.livingCells) (adjacentCells ( a, b ) model))


buildAllPossibleCellsInGrid : Model -> Set.Set ( Int, Int )
buildAllPossibleCellsInGrid model =
    Set.fromList (List.concatMap (\i -> List.map (\j -> ( i, j )) (List.range 0 (model.width - 1))) (List.range 0 (model.height - 1)))


determineNextGeneration : Model -> Set.Set ( Int, Int )
determineNextGeneration model =
    Set.filter (\i -> livesInNextGeneration i model) (buildAllPossibleCellsInGrid model)


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
            ( { model | livingCells = determineNextGeneration model, history = model.livingCells :: model.history }, Cmd.none )

        GoToLastState ->
            ( { model
                | livingCells = List.head model.history |> Maybe.withDefault Set.empty
                , history = List.tail model.history |> Maybe.withDefault []
              }
            , Cmd.none
            )


port changeWidth : (Int -> msg) -> Sub msg


port changeHeight : (Int -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ changeWidth ChangeWidth, changeHeight ChangeHeight ]


mapCellComponentWithBreak : Int -> Int -> Int
mapCellComponentWithBreak input breakAt =
    if (input < 0) then
        breakAt - 1
    else if (input >= breakAt) then
        0
    else
        input


mapCellWithBreak : ( Int, Int ) -> Model -> ( Int, Int )
mapCellWithBreak ( a, b ) model =
    ( mapCellComponentWithBreak a model.height, mapCellComponentWithBreak b model.width )


adjacentCells : ( Int, Int ) -> Model -> Set.Set ( Int, Int )
adjacentCells ( a, b ) model =
    if (a < 0 || b < 0 || a >= model.height || b >= model.height) then
        Set.empty
    else
        Set.map (\x -> mapCellWithBreak x model) (Set.fromList [ ( a - 1, b - 1 ), ( a - 1, b ), ( a - 1, b + 1 ), ( a, b - 1 ), ( a, b + 1 ), ( a + 1, b - 1 ), ( a + 1, b ), ( a + 1, b + 1 ) ])


square : ( Int, Int ) -> Model -> Html.Html Msg
square ( a, b ) model =
    let
        class =
            if (Set.member ( a, b ) model.livingCells) then
                "livingCell"
            else
                "cell"

        classSuffix =
            if (( a, b ) == model.hoveredCell || Set.member ( a, b ) (adjacentCells model.hoveredCell model)) then
                "InFocus"
            else
                ""
    in
        Html.button
            [ Attributes.class (class ++ classSuffix)
            , Events.onMouseEnter (HoverCell ( a, b ))
            , Attributes.style [ ( "width", (toString (100 / (toFloat model.width))) ++ "%" ) ]
            , Events.onClick (ChangeCell ( a, b ))
            ]
            []


inputRow : Model -> Int -> Html.Html Msg
inputRow model rowIndex =
    Html.div [ Attributes.class "row" ] (List.map (\i -> square ( rowIndex, i ) model) (List.range 0 (model.width - 1)))


view : Model -> Html.Html Msg
view model =
    Html.div [ Attributes.class "mainRow" ]
        [ Html.div
            [ Attributes.classList [ ( "text-center", True ), ( "mainRowGlyphiconWrapper", True ) ] ]
            [ Html.span [ Events.onClick GoToLastState, Attributes.classList [ ( "glyphicon", True ), ( "glyphicon-center", True ), ( "glyphicon-chevron-left", True ), ( "myButton", True ) ] ] [] ]
        , Html.div [ Events.onMouseLeave (HoverCell ( -1, -1 )) ] (List.map (inputRow model) (List.range 0 (model.height - 1)))
        , Html.div [ Attributes.classList [ ( "text-center", True ), ( "mainRowGlyphiconWrapper", True ) ] ]
            [ Html.span [ Events.onClick CalculateNextGeneration, Attributes.classList [ ( "glyphicon", True ), ( "glyphicon-center", True ), ( "glyphicon-chevron-right", True ), ( "myButton", True ) ] ] []
            ]
        ]
