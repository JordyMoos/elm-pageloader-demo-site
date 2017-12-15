module Page.Error exposing (Model, view)

import Html exposing (..)
import View.Layout as Layout


type alias Model =
    String


view : Model -> Html msg
view error =
    Layout.full <|
        div
            []
            [ h1 [] [ text "Ooops error" ]
            , p [] [ text error ]
            ]
