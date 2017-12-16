module View.Layout exposing (full, withSide)

import Html exposing (..)
import Html.Attributes exposing (..)


full : Html msg -> Html msg
full content =
    div
        []
        [ header
        , navBar
        , div []
            [ article [ contentStyle ] [ content ]
            ]
        ]


withSide : Html msg -> Html msg -> Html msg
withSide content side =
    div
        []
        [ header
        , navBar
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
        ]


navBar : Html msg
navBar =
    Html.nav
        [ navBarStyle ]
        [ ul
            [ navBarUlStyle ]
            [ a [ href "#" ] [ li [ navBarLiStyle ] [ text "Home" ] ]
            , a [ href "#/slow" ] [ li [ navBarLiStyle ] [ text "Slow Page" ] ]
            ]
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


navBarStyle : Attribute msg
navBarStyle =
    style
        [ ( "backgroundColor", "lightGrey" )
        , ( "position", "relative" )
        ]


navBarUlStyle : Attribute msg
navBarUlStyle =
    style
        [ ( "margin", "0" )
        , ( "padding", "0 0 5px 0" )
        ]


navBarLiStyle : Attribute msg
navBarLiStyle =
    style
        [ ( "margin", "0px 5px" )
        , ( "padding", "5px 20px" )
        , ( "display", "inline" )
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
