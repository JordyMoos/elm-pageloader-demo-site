module View.Layout exposing (full, withSide)

import Html exposing (..)
import Html.Attributes exposing (..)


full : Html msg -> Html msg
full content =
    div
        []
        [ header
        , div []
            [ article [ contentStyle ] [ content ]
            ]
        ]


withSide : Html msg -> Html msg -> Html msg
withSide content side =
    div
        []
        [ header
        , div [ containerStyle ]
            [ article [ contentStyle ] [ content ]
            , aside [ sideStyle ] [ side ]
            ]
        ]


header : Html msg
header =
    Html.header
        [ headerStyle ]
        []


headerStyle : Attribute msg
headerStyle =
    style
        [ ( "backgroundColor", "lightGrey" )
        , ( "height", "150px" )
        ]


containerStyle : Attribute msg
containerStyle =
    style
        [ ( "position", "relative" )
        , ( "padding", "0 150px 0 0" )
        ]


contentStyle : Attribute msg
contentStyle =
    style
        [ ( "margin", "20px 0" )
        ]


sideStyle : Attribute msg
sideStyle =
    style
        [ ( "position", "absolute" )
        , ( "top", "0" )
        , ( "bottom", "0" )
        , ( "right", "0" )
        , ( "width", "130px" )
        , ( "backgroundColor", "red" )
        ]
