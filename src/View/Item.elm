module View.Item exposing (card)

import Data.Item exposing (Item)
import Html exposing (..)
import Html.Attributes exposing (..)


card : Item -> Html msg
card category =
    div
        [ cardStyle ]
        [ h5 [] [ text category.title ]
        ]


cardStyle : Attribute msg
cardStyle =
    style
        [ ( "border", "3px solid black" )
        , ( "padding", "5px 5px 50px 5px" )
        , ( "margin", "10px" )
        ]
