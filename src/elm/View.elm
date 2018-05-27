module View exposing (view)

import Model exposing (..)
import GameOfLife as GameOfLife
import Html as Html
import Html.Attributes as Attributes
import Html.Events as Events
import Set as Set
import Util exposing (..)


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

        interactionEvents =
            if not model.presentationMode then
                [ Events.onMouseEnter (HoverCell ( a, b )), Events.onClick (ChangeCell ( a, b )) ]
            else
                []
    in
        Html.button
            ([ Attributes.class (class ++ classSuffix)
             , Attributes.id ("cell_" ++ (toString a) ++ "_" ++ (toString b))
             , Attributes.style [ ( "width", (toString (100 / (toFloat model.width))) ++ "%" ) ]
             ]
                ++ interactionEvents
            )
            []


inputRow : Model -> Int -> Html.Html Msg
inputRow model rowIndex =
    Html.div
        [ Attributes.class "row"
        , Attributes.style [ ( "height", (toString (72 / (toFloat model.height))) ++ "vh" ) ]
        ]
        (List.map (\i -> square ( rowIndex, i ) model) (List.range 0 (model.width - 1)))


historyNavigationButton : Bool -> String -> Msg -> Html.Html Msg
historyNavigationButton active direction msg =
    let
        spanAttributes =
            if (active) then
                [ Events.onClick msg ]
            else
                []
    in
        Html.div
            [ Attributes.classList [ ( "text-center", True ), ( "mainRowGlyphiconWrapper", True ) ] ]
            [ Html.span
                ([ (Attributes.classList
                        [ ( "glyphicon", True )
                        , ( "glyphicon-center", True )
                        , ( ("glyphicon-chevron-" ++ direction), active )
                        , ( "myButton", active )
                        ]
                   )
                 , Attributes.id ("history_" ++ direction)
                 ]
                    ++ spanAttributes
                )
                []
            ]


buttonBar : Model -> Html.Html Msg
buttonBar model =
    Html.div [ Attributes.class "container-fluid", Attributes.style [ ( "background-color", "#eee" ), ( "padding", "10px 50px" ) ] ]
        [ Html.div [ Attributes.class "row" ]
            (buttonBarButton ( "trash", "Clear" ) (isCleanButtonClickable model) Clear
                ++ buttonBarButton ( "play", "Run it" ) (isRunButtonClickable model) (EnableAutoRun True)
            )
        ]


buttonBarId iconName =
    if "play" == iconName then
        "runButton"
    else
        "cleanButton"


buttonBarButton : ( String, String ) -> Bool -> Msg -> List (Html.Html Msg)
buttonBarButton ( iconName, text ) canRun msg =
    let
        clickEvent =
            if (canRun) then
                [ Events.onClick msg ]
            else
                []
    in
        [ Html.div [ Attributes.class "col-xs-2" ] []
        , Html.button
            ([ Attributes.id (buttonBarId iconName)
             , Attributes.type_ "button"
             , Attributes.classList [ ( "col-xs-3", True ), ( "btn", True ), ( "btn-lg", True ), ( "btn-default", True ), ( "disabled", not canRun ) ]
             ]
                ++ clickEvent
            )
            [ Html.span [ Attributes.classList [ ( "glyphicon", True ), ( ("glyphicon-" ++ iconName), True ), ( "glyphicon-center", True ) ] ] []
            , Html.text (" " ++ text)
            ]
        ]


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.div [ Attributes.class "mainRow" ]
            [ historyNavigationButton (not (List.isEmpty model.history)) "left" GoToLastState
            , Html.div [ Events.onMouseLeave (HoverCell ( -1, -1 )) ] (List.map (inputRow model) (List.range 0 (model.height - 1)))
            , historyNavigationButton (isRunButtonClickable model) "right" CalculateNextGeneration
            ]
        , buttonBar model
        ]
