module Request.Category exposing (list)

import Http
import Data.Category as Category exposing (Category)
import RemoteData
import Request.Helpers exposing (apiUrl)


list : (RemoteData.WebData (List Category) -> msg) -> Cmd msg
list msg =
    Http.get listUrl Category.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


listUrl : String
listUrl =
    apiUrl "/categories.json"
