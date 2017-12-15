module Main exposing (..)

import Routing
import Page.NotFound as NotFound
import Page.Blank as Blank
import Page.Error as Error
import Page.Home.LoadingHome as LoadingHome
import Page.Home.Home as Home
import Page.Category.LoadingCategory as LoadingCategory
import Page.Category.Category as Category
import PageLoader exposing (PageState(Loaded, Transitioning))
import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)


type Page
    = BlankPage
    | NotFoundPage
    | ErrorPage Error.Model
    | HomePage Home.Model
    | CategoryPage Category.Model


type Loading
    = LoadingHome LoadingHome.Model
    | LoadingCategory LoadingCategory.Model


type alias Model =
    { pageState : PageState Page Loading
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    setRoute (Routing.fromLocation location) initModel


initModel : Model
initModel =
    { pageState = Loaded BlankPage }


main : Program Never Model Msg
main =
    Navigation.program ChangeLocation
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


type Msg
    = ChangeLocation Navigation.Location
    | LoadingHomeMsg LoadingHome.Msg
    | LoadingCategoryMsg LoadingCategory.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageState ) of
        ( ChangeLocation location, _ ) ->
            setRoute (Routing.fromLocation location) model

        ( LoadingHomeMsg subMsg, Transitioning oldPage (LoadingHome subModel) ) ->
            let
                ( newPageState, newCmd ) =
                    PageLoader.defaultTransitionStatusHandler
                        (LoadingHome.update subMsg subModel)
                        oldPage
                        LoadingHome
                        LoadingHomeMsg
                        HomePage
                        ErrorPage
            in
                ( { model | pageState = newPageState }, newCmd )

        ( LoadingCategoryMsg subMsg, Transitioning oldPage (LoadingCategory subModel) ) ->
            let
                ( newPageState, newCmd ) =
                    PageLoader.defaultTransitionStatusHandler
                        (LoadingCategory.update subMsg subModel)
                        oldPage
                        LoadingCategory
                        LoadingCategoryMsg
                        CategoryPage
                        ErrorPage
            in
                ( { model | pageState = newPageState }, newCmd )

        ( _, _ ) ->
            let
                _ =
                    Debug.log "Ignoring wrong message for state" (toString ( msg, model.pageState ))
            in
                ( model, Cmd.none )


setRoute : Maybe Routing.Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | pageState = Loaded NotFoundPage } ! []

        Just Routing.Home ->
            let
                oldPage =
                    PageLoader.visualPage model.pageState

                ( newModel, newCmd ) =
                    LoadingHome.init
            in
                { model | pageState = Transitioning oldPage (LoadingHome newModel) }
                    ! [ Cmd.map LoadingHomeMsg newCmd ]

        Just (Routing.Category categoryId) ->
            let
                oldPage =
                    PageLoader.visualPage model.pageState

                ( newModel, newCmd ) =
                    LoadingCategory.init categoryId
            in
                { model | pageState = Transitioning oldPage (LoadingCategory newModel) }
                    ! [ Cmd.map LoadingCategoryMsg newCmd ]


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage page

        Transitioning oldPage transitionData ->
            viewPage oldPage
                |> viewLoader


viewPage : Page -> Html Msg
viewPage page =
    case page of
        BlankPage ->
            Blank.view

        NotFoundPage ->
            NotFound.view

        ErrorPage model ->
            Error.view model

        HomePage model ->
            Home.view model

        CategoryPage model ->
            Category.view model


viewLoader : Html Msg -> Html Msg
viewLoader layout =
    div
        []
        [ layout
        , div [ loaderStyle ] [ text "Loading" ]
        ]


loaderStyle : Attribute msg
loaderStyle =
    style
        [ ( "position", "absolute" )
        , ( "top", "0" )
        , ( "right", "0" )
        , ( "padding", "5px" )
        , ( "backgroundColor", "grey" )
        ]
