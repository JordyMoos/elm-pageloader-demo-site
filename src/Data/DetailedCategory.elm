module Data.DetailedCategory exposing (DetailedCategory, empty, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias DetailedCategory =
    { id : Int
    , title : String
    , description : String
    }


empty : DetailedCategory
empty =
    { id = 0
    , title = ""
    , description = ""
    }


decoder : Decoder DetailedCategory
decoder =
    decode DetailedCategory
        |> required "id" Decode.int
        |> required "title" Decode.string
        |> required "description" Decode.string
