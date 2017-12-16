module Page.Slow.LoadingSlow exposing (Model, Msg(..), init, update)

import Data.Category as Category exposing (Category)
import Request.Category as CategoryRequest
import RemoteData exposing (WebData)
import Page.Slow.Slow as Slow
import PageLoader exposing (TransitionStatus)
import PageLoader.Progression as Progression
import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt
import Process
import Time
import Task


type alias Model =
    { sleeps : DependencyStatus.Status
    , categories : WebData (List Category)
    }


type Msg
    = SleepResponse ()
    | CategoryResponse (WebData (List Category))


init : TransitionStatus Model Msg Slow.Model
init =
    asTransitionStatus <|
        { sleeps = DependencyStatus.Pending { total = 3, finished = 0 }
        , categories = RemoteData.Loading
        }
            ! [ sleep (1.0 * Time.second)
              , sleep (2.0 * Time.second)
              , sleep (3.0 * Time.second)
              , CategoryRequest.list CategoryResponse
              ]


update : Msg -> Model -> TransitionStatus Model Msg Slow.Model
update msg model =
    asTransitionStatus <|
        case msg of
            SleepResponse _ ->
                { model | sleeps = addFinished model.sleeps } ! []

            CategoryResponse response ->
                { model | categories = response } ! []


asTransitionStatus : ( Model, Cmd Msg ) -> TransitionStatus Model Msg Slow.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultDependencyStatusListHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            { categories = RemoteData.withDefault [] model.categories }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ RemoteDataExt.asStatus model.categories
    , model.sleeps
    ]


sleep : Time.Time -> Cmd Msg
sleep time =
    Process.sleep time
        |> Task.perform SleepResponse



{- This method should be in the library -}


addFinished : DependencyStatus.Status -> DependencyStatus.Status
addFinished status =
    case status of
        DependencyStatus.Failed ->
            DependencyStatus.Failed

        DependencyStatus.Success ->
            DependencyStatus.Success

        DependencyStatus.Pending progression ->
            if progression.total == progression.finished + 1 then
                DependencyStatus.Success
            else
                DependencyStatus.Pending (Progression.add progression { total = 0, finished = 1 })
