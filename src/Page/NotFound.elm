module Page.NotFound exposing (view)

import Html exposing (..)
import View.Layout as Layout


view : Html msg
view =
    Layout.full <|
        div
            []
            [ h1 [] [ text "404 Not Found" ]
            ]
