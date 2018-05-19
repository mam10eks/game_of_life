import Html
import Html.Events as Events

type alias Model = Int
model: Model
model = 0

type Msg = Increment | Decrement | Reset

main = Html.beginnerProgram {view= view, update= update, model= model}

update: Msg -> Model -> Model
update msg model =
    case msg of
        Increment
            -> model + 1

        Decrement
            -> model - 1
        Reset
            -> 0

view: Model -> Html.Html Msg
view model =
    Html.div []
    [
        Html.button [ Events.onClick Increment ] [ Html.text "+" ],
        Html.div [] [ Html.text (toString model) ],
        Html.button [ Events.onClick Decrement ] [ Html.text "-" ],
        Html.div[] [ Html.button [ Events.onClick Reset ] [Html.text "RESET" ] ]
    ]
