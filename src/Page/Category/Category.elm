module Page.Category.Category exposing (Model, view)

import Data.Item exposing (Item)
import Data.Category exposing (Category)
import Data.DetailedCategory exposing (DetailedCategory)
import View.Layout as Layout
import View.Side as SideView
import View.Item as ItemView
import Html exposing (..)


type alias Model =
    { detailedCategory : DetailedCategory
    , items : List Item
    , categories : List Category
    }


view : Model -> Html msg
view model =
    Layout.withSide
        (content model)
        (SideView.categoriesMenu model.categories)


content : Model -> Html msg
content { detailedCategory, items } =
    div
        []
        [ h1 [] [ text ("Category " ++ detailedCategory.title) ]
        , div []
            [ p [] [ text detailedCategory.description ]
            ]
        , div [] (List.map ItemView.card items)
        ]
