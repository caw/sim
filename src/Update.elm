port module Update exposing (update)

import Debug exposing (log, toString)
import Json.Encode as E
import Model exposing (Model, Msg(..), Patient, State(..))
import Utilities exposing (..)


port play : E.Value -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            if model.state == Running then
                let
                    newRunningTime =
                        model.runningTime + 1

                    newPatient =
                        updatePatient model.patient

                    newAgenda =
                        updateAgenda model

                    newInterventions =
                        updateInterventions model
                in
                ( { model
                    | patient = newPatient
                    , agenda = newAgenda
                    , interventions = newInterventions
                    , runningTime = newRunningTime
                  }
                , play (E.bool True)
                )

            else
                ( model, Cmd.none )

        Run ->
            ( { model | state = Running }, Cmd.none )

        Pause ->
            ( { model | state = Paused }, Cmd.none )

        Finish ->
            ( { model | state = Finished }, Cmd.none )

        SpeedUpSim ->
            ( { model | speedUp = Basics.min (model.speedUp + 0.1) 10 }, Cmd.none )

        SlowDownSim ->
            ( { model | speedUp = Basics.max (model.speedUp - 0.1) 0.1 }, Cmd.none )

        HSUpdate str ->
            case String.toFloat str of
                Just f ->
                    let
                        patient =
                            model.patient

                        newPatient =
                            { patient | hs = f / 10.0 }
                    in
                    ( { model | patient = newPatient }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )


updatePatient patient =
    ntimes 1000 updateCirculation patient


updateAgenda agenda =
    0


updateInterventions model =
    0


starling : Float -> Float
starling pra =
    let
        r2 =
            6.0 * (pra + 4)

        r3 =
            r2 ^ 2.5
    in
    ((r3 / (5000 + r3)) * 13 + 0.5) / secondsInMinute


updateCirculation : Patient -> Patient
updateCirculation p =
    let
        dt =
            0.001

        vrae =
            p.vra - p.vra0

        pra =
            vrae / p.cra

        fan =
            starling pra

        fa =
            fan * p.hs

        dva =
            fa - p.fc

        vae =
            p.va - p.va0

        pa =
            vae / p.ca

        pga =
            pa - p.pv

        fc =
            pga / p.ra

        dvv =
            fc - p.fv

        vve =
            p.vv - p.vv0

        pv =
            vve / p.cv

        pgv =
            pv - pra

        fv =
            pgv / p.rv

        dvra =
            fv - fa

        va =
            p.va + dva * dt

        vv =
            p.vv + dvv * dt

        vra =
            p.vra + dvra * dt
    in
    { p
        | vrae = vrae
        , pra = pra
        , fan = fan
        , fa = fa
        , vae = vae
        , pa = pa
        , pga = pga
        , fc = fc
        , vve = vve
        , pv = pv
        , pgv = pgv
        , fv = fv
        , va = va
        , vv = vv
        , vra = vra
    }
