module Request.Item exposing (forCategory, popular)

import Http
import Data.Item as Item exposing (Item)
import RemoteData
import Request.Helpers exposing (apiUrl)


forCategory : (RemoteData.WebData (List Item) -> msg) -> Int -> Cmd msg
forCategory msg categoryId =
    Http.get (categoryItemsUrl categoryId) Item.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


popular : (RemoteData.WebData (List Item) -> msg) -> Cmd msg
popular msg =
    Http.get popularUrl Item.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


categoryItemsUrl : Int -> String
categoryItemsUrl id =
    apiUrl <|
        String.concat
            [ "/category-"
            , toString id
            , "-items.json"
            ]


popularUrl : String
popularUrl =
    apiUrl "/popular-items.json"
