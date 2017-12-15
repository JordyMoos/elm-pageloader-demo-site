module Data.Category exposing (Category, empty, listDecoder, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Category =
    { id : Int
    , title : String
    }


empty : Category
empty =
    { id = 0
    , title = ""
    }


listDecoder : Decoder (List Category)
listDecoder =
    Decode.list decoder


decoder : Decoder Category
decoder =
    decode Category
        |> required "id" Decode.int
        |> required "title" Decode.string
