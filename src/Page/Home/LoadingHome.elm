module Page.Home.LoadingHome exposing (Model, Msg(..), init, update)

import Data.Category as Category exposing (Category)
import Data.Item as Item exposing (Item)
import Request.Category as CategoryRequest
import Request.Item as ItemRequest
import RemoteData exposing (WebData)
import Page.Home.Home as Home
import PageLoader exposing (TransitionStatus(Pending, Success, Failed))
import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt


type alias Model =
    { items : WebData (List Item)
    , categories : WebData (List Category)
    }


type Msg
    = ItemResponse (WebData (List Item))
    | CategoryResponse (WebData (List Category))


init : ( Model, Cmd Msg )
init =
    { items = RemoteData.Loading
    , categories = RemoteData.Loading
    }
        ! [ ItemRequest.popular ItemResponse
          , CategoryRequest.list CategoryResponse
          ]


update : Msg -> Model -> TransitionStatus Model Msg Home.Model
update msg model =
    asTransitionStatus <|
        case msg of
            ItemResponse response ->
                { model | items = response } ! []

            CategoryResponse response ->
                { model | categories = response } ! []


asTransitionStatus : ( Model, Cmd Msg ) -> TransitionStatus Model Msg Home.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultDependencyStatusListHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            { items = RemoteData.withDefault [] model.items
            , categories = RemoteData.withDefault [] model.categories
            }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ RemoteDataExt.asStatus model.items
    , RemoteDataExt.asStatus model.categories
    ]
