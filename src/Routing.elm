module Routing exposing (Route(..), fromLocation)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Home
    | Category Int


fromLocation : Location -> Maybe Route
fromLocation =
    parseHash matchers


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map Category (s "category" </> int)
        ]
