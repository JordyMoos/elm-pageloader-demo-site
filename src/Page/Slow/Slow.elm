module Page.Slow.Slow exposing (Model, init, view)

import Data.Category exposing (Category)
import View.Layout as Layout
import View.Side as SideView
import View.Item as ItemView
import Html exposing (..)


type alias Model =
    { categories : List Category
    }


init : Model -> ( Model, Cmd msg )
init model =
    model ! []


view : Model -> Html msg
view model =
    Layout.withSide
        content
        (SideView.categoriesMenu model.categories)


content : Html msg
content =
    div
        []
        [ h1 [] [ text "Slow loading page" ]
        , div []
            [ p [] [ text "Has finally loaded" ]
            ]
        ]
