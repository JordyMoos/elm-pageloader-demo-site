module Data.Item exposing (Item, listDecoder, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Item =
    { id : Int
    , title : String
    }


listDecoder : Decoder (List Item)
listDecoder =
    Decode.list decoder


decoder : Decoder Item
decoder =
    decode Item
        |> required "id" Decode.int
        |> required "title" Decode.string
