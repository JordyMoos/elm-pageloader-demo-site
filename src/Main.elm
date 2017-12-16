module Main exposing (..)

import Routing
import Page.NotFound as NotFound
import Page.Blank as Blank
import Page.Error as Error
import Page.Home.LoadingHome as LoadingHome
import Page.Home.Home as Home
import Page.Category.LoadingCategory as LoadingCategory
import Page.Category.Category as Category
import Page.Slow.LoadingSlow as LoadingSlow
import Page.Slow.Slow as Slow
import PageLoader exposing (PageState(Loaded, Transitioning), TransitionStatus(..))
import PageLoader.Progression as Progression
import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)


type Page
    = BlankPage
    | NotFoundPage
    | ErrorPage Error.Model
    | HomePage Home.Model
    | CategoryPage Category.Model
    | SlowPage Slow.Model


type Loading
    = LoadingHome LoadingHome.Model Progression.Progression
    | LoadingCategory LoadingCategory.Model Progression.Progression
    | LoadingSlow LoadingSlow.Model Progression.Progression


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
    = NoOp
    | ChangeLocation Navigation.Location
    | LoadingHomeMsg LoadingHome.Msg
    | LoadingCategoryMsg LoadingCategory.Msg
    | LoadingSlowMsg LoadingSlow.Msg


processLoading :
    (String -> page) -- ErrorPage
    -> (loadingModel -> Progression.Progression -> loader) -- LoadingHome
    -> (loadingMsg -> msg) -- LoadingHomeMsg
    -> (newModel -> page) -- HomePage
    -> (newData -> ( newModel, Cmd newMsg )) -- Home.init
    -> (newMsg -> msg) -- HomeMsg / NoOp
    -> page -- oldPage
    -> TransitionStatus loadingModel loadingMsg newData -- TransitionStatus
    -> ( PageState page loader, Cmd msg )
processLoading errorPage loader loaderMsg successPage successPageInit successPageMsg oldPage transitionStatus =
    case transitionStatus of
        Pending ( model, cmd ) progression ->
            ( Transitioning oldPage (loader model progression), Cmd.map loaderMsg cmd )

        Success newData ->
            let
                ( model, cmd ) =
                    successPageInit newData
            in
                ( Loaded (successPage model), Cmd.map successPageMsg cmd )

        Failed error ->
            ( Loaded (errorPage error), Cmd.none )


processLoadingHome : Page -> TransitionStatus LoadingHome.Model LoadingHome.Msg Home.Model -> ( PageState Page Loading, Cmd msg )
processLoadingHome =
    processLoading ErrorPage LoadingHome LoadingHomeMsg HomePage Home.init NoOp


processLoadingCategory : Page -> TransitionStatus LoadingCategory.Model LoadingCategory.Msg Category.Model -> ( PageState Page Loading, Cmd msg )
processLoadingCategory =
    processLoading ErrorPage LoadingCategory LoadingCategoryMsg CategoryPage Category.init NoOp


processLoadingSlow : Page -> TransitionStatus LoadingSlow.Model LoadingSlow.Msg Slow.Model -> ( PageState Page Loading, Cmd msg )
processLoadingSlow =
    processLoading ErrorPage LoadingSlow LoadingSlowMsg SlowPage Slow.init NoOp


updatePageState : Model -> ( PageState page loader, Cmd msg ) -> ( Model, Cmd msg )
updatePageState model ( pageState, cmd ) =
    ( { model | pageState = pageState }, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageState ) of
        ( ChangeLocation location, _ ) ->
            setRoute (Routing.fromLocation location) model

        ( LoadingHomeMsg subMsg, Transitioning oldPage (LoadingHome subModel _) ) ->
            processLoadingHome oldPage (LoadingHome.update subMsg subModel)
                |> updatePageState model

        ( LoadingCategoryMsg subMsg, Transitioning oldPage (LoadingCategory subModel _) ) ->
            processLoadingCategory oldPage (LoadingCategory.update subMsg subModel)
                |> updatePageState model

        ( LoadingSlowMsg subMsg, Transitioning oldPage (LoadingSlow subModel _) ) ->
            processLoadingSlow oldPage (LoadingSlow.update subMsg subModel)
                |> updatePageState model

        ( _, _ ) ->
            let
                _ =
                    Debug.log "Ignoring wrong message for state" (toString ( msg, model.pageState ))
            in
                ( model, Cmd.none )


setRoute : Maybe Routing.Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        oldPage =
            PageLoader.visualPage model.pageState
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded NotFoundPage } ! []

            Just Routing.Home ->
                processLoadingHome oldPage LoadingHome.init
                    |> updatePageState model

            Just (Routing.Category categoryId) ->
                processLoadingCategory oldPage (LoadingCategory.init categoryId)
                    |> updatePageState model

            Just Routing.Slow ->
                processLoadingSlow oldPage (LoadingSlow.init)
                    |> updatePageState model


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage page

        Transitioning oldPage loader ->
            viewPage oldPage
                |> viewLoading (extractProgression loader)


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

        SlowPage model ->
            Slow.view model


viewLoading : Progression.Progression -> Html Msg -> Html Msg
viewLoading progression layout =
    div
        []
        [ layout
        , div [ loaderStyle progression ] []
        ]


loaderStyle : Progression.Progression -> Attribute msg
loaderStyle progression =
    let
        percentile =
            (progression.finished * 100) // (progression.total * 100)
    in
        style
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "left", "0" )
            , ( "width", (toString percentile) ++ "%" )
            , ( "height", "10px" )
            , ( "backgroundColor", "grey" )
            ]


extractProgression : Loading -> Progression.Progression
extractProgression loader =
    case loader of
        LoadingHome _ progression ->
            progression

        LoadingCategory _ progression ->
            progression

        LoadingSlow _ progression ->
            progression
