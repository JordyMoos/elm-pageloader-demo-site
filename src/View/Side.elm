module View.Side exposing (categoriesMenu)

import Data.Category exposing (Category)
import Html exposing (..)
import Html.Attributes exposing (..)


categoriesMenu : List Category -> Html msg
categoriesMenu categories =
    nav
        []
        [ ul
            []
            (List.map
                categoryView
                categories
            )
        ]


categoryView : Category -> Html msg
categoryView category =
    li
        []
        [ a [ href "#" ] [ text category.title ]
        ]
