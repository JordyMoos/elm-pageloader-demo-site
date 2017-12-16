module Page.Category.LoadingCategory exposing (Model, Msg(..), init, update)

import Data.Category as Category exposing (Category)
import Data.DetailedCategory as DetailedCategory exposing (DetailedCategory)
import Data.Item as Item exposing (Item)
import Request.Category as CategoryRequest
import Request.Item as ItemRequest
import Request.DetailedCategory as DetailedCategoryRequest
import RemoteData exposing (WebData)
import Page.Category.Category as CategoryPage
import PageLoader exposing (TransitionStatus(Pending, Success, Failed))
import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt


type alias Model =
    { detailedCategory : WebData DetailedCategory
    , items : WebData (List Item)
    , categories : WebData (List Category)
    }


type Msg
    = DetailedCategoryResponse (WebData DetailedCategory)
    | ItemResponse (WebData (List Item))
    | CategoryResponse (WebData (List Category))


init : Int -> TransitionStatus Model Msg CategoryPage.Model
init categoryId =
    asTransitionStatus <|
        { detailedCategory = RemoteData.Loading
        , items = RemoteData.Loading
        , categories = RemoteData.Loading
        }
            ! [ DetailedCategoryRequest.byId DetailedCategoryResponse categoryId
              , ItemRequest.forCategory ItemResponse categoryId
              , CategoryRequest.list CategoryResponse
              ]


update : Msg -> Model -> TransitionStatus Model Msg CategoryPage.Model
update msg model =
    asTransitionStatus <|
        case msg of
            DetailedCategoryResponse response ->
                { model | detailedCategory = response } ! []

            ItemResponse response ->
                { model | items = response } ! []

            CategoryResponse response ->
                { model | categories = response } ! []


asTransitionStatus : ( Model, Cmd Msg ) -> TransitionStatus Model Msg CategoryPage.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultDependencyStatusListHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            { detailedCategory = RemoteData.withDefault DetailedCategory.empty model.detailedCategory
            , items = RemoteData.withDefault [] model.items
            , categories = RemoteData.withDefault [] model.categories
            }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ RemoteDataExt.asStatus model.detailedCategory
    , RemoteDataExt.asStatus model.items
    , RemoteDataExt.asStatus model.categories
    ]
