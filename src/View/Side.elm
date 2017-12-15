module View.Side exposing (categoriesMenu)

import Data.Category as Category exposing (Category)
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
        [ a
            [ href (Category.url category) ]
            [ text category.title ]
        ]
