module Page.Blank exposing (view)

import View.Layout as Layout
import Html exposing (..)


view : Html msg
view =
    Layout.withSide
        (text "")
        (text "")
