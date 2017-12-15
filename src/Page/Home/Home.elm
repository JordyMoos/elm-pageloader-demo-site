module Page.Home.Home exposing (Model, view)

import Data.Item exposing (Item)
import Data.Category exposing (Category)
import View.Layout as Layout
import View.Side as SideView
import View.Item as ItemView
import Html exposing (..)


type alias Model =
    { items : List Item
    , categories : List Category
    }


view : Model -> Html msg
view model =
    Layout.withSide
        (content model)
        (SideView.categoriesMenu model.categories)


content : Model -> Html msg
content model =
    div
        []
        [ h1 [] [ text "Popular items" ]
        , div [] (List.map ItemView.card model.items)
        ]
