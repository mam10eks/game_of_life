port module Main exposing (..)

import Html as Html
import Set as Set
import Html.Attributes as Attributes
import Html.Events as Events
import Result as Result


main =
    Html.program { init = ( model, Cmd.none ), view = view, update = update, subscriptions = subscriptions }


type alias Model =
    { width : Int, height : Int, livingCells : Set.Set ( Int, Int ) }


model =
    { width = 4, height = 4, livingCells = Set.empty }


type Msg
    = ChangeWidth Int
    | ChangeHeight Int
    | ChangeCell ( Int, Int )


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
            ( { model | width = clippedSize newWidth }, Cmd.none )

        ChangeHeight newHeight ->
            ( { model | height = clippedSize newHeight }, Cmd.none )

        ChangeCell ( a, b ) ->
            ( { model | livingCells = toggleSetElement ( a, b ) model.livingCells |> removeCellsOutsideOfGrid model }, Cmd.none )


port changeWidth : (Int -> msg) -> Sub msg


port changeHeight : (Int -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ changeWidth ChangeWidth, changeHeight ChangeHeight ]


square : ( Int, Int ) -> Model -> Html.Html Msg
square ( a, b ) model =
    let
        color =
            if (Set.member ( a, b ) model.livingCells) then
                "red"
            else
                "blue"
    in
        Html.button
            [ Attributes.class "square"
            , Attributes.style [ ( "backgroundColor", color ) ]
            , Events.onClick (ChangeCell ( a, b ))
            ]
            [ Html.text (toString ( a, b )) ]


inputRow : Model -> Int -> Html.Html Msg
inputRow model rowIndex =
    Html.div [ Attributes.class "row" ] (List.map (\i -> square ( rowIndex, i ) model) (List.range 0 (model.width - 1)))


view : Model -> Html.Html Msg
view model =
    Html.div [] (List.map (inputRow model) (List.range 0 (model.height - 1)))
