module View exposing (view)

import Model exposing (..)
import GameOfLife as GameOfLife
import Html as Html
import Html.Attributes as Attributes
import Html.Events as Events
import Set as Set


square : ( Int, Int ) -> Model -> Html.Html Msg
square ( a, b ) model =
    let
        class =
            if (Set.member ( a, b ) model.livingCells) then
                "livingCell"
            else
                "cell"

        classSuffix =
            if (( a, b ) == model.hoveredCell || Set.member ( a, b ) (GameOfLife.adjacentCells model.hoveredCell model)) then
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
