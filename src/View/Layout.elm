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
        [ a
            [ logoStyle, href "#" ]
            [ text "Elm PageLoader Demo" ]
        , a [ href "#slow" ] [ text "Slow page" ]
        ]


logoStyle : Attribute msg
logoStyle =
    style
        [ ( "padding", "50px" )
        , ( "fontSize", "20px" )
        , ( "display", "block" )
        ]


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
        , ( "padding", "0 200px 0 0" )
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
        , ( "width", "190px" )
        , ( "backgroundColor", "red" )
        ]
