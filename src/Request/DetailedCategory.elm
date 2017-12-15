module Request.DetailedCategory exposing (byId)

import Http
import Data.DetailedCategory as DetailedCategory exposing (DetailedCategory)
import RemoteData
import Request.Helpers exposing (apiUrl)


byId : (RemoteData.WebData DetailedCategory -> msg) -> Int -> Cmd msg
byId msg categoryId =
    Http.get (categoryUrl categoryId) DetailedCategory.decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


categoryUrl : Int -> String
categoryUrl categoryId =
    apiUrl <|
        String.concat
            [ "category-"
            , toString categoryId
            , "-details.json"
            ]
