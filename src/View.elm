port module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Model exposing (Model, Msg(..), State(..), UIButton(..))
import Round exposing (..)
import Utilities exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ headerView model
        , simControlView model
        , line
        , circulationView model
        , line
        , circulationControlsView model
        , line
        , audioView model
        ]


line =
    hr [] []


headerView : Model -> Html Msg
headerView model =
    div [ id "header" ]
        [ img [ src "images/MULogo.jpg", width 100, height 100 ] []
        , div [ id "MuSIM" ] [ text "MuSIM" ]
        , div [ id "sim_ui_mode" ]
            [ div [ class "ui_mode" ] [ text "End User" ]
            , div [ class "ui_mode" ] [ text "Design" ]
            , div [ class "active_ui_mode" ] [ text "Low Level" ]
            ]
        ]


btnState : UIButton -> Model -> Bool
btnState btn model =
    let
        state =
            model.state
    in
    case btn of
        RunButton ->
            state == Running || state == Finished

        PauseButton ->
            state == NotStarted || state == Finished || state == Paused

        FinishButton ->
            state == NotStarted || state == Finished


simControlView : Model -> Html Msg
simControlView model =
    div [ id "time_control_container" ]
        [ div [ id "running_time" ] [ text (toMinSec model.runningTime) ]
        , div [ id "speedup_container" ]
            [ button [ onClick SlowDownSim ] [ text "Slower" ]
            , div [ id "speedup" ] [ text (Round.round 1 model.speedUp) ]
            , button [ onClick SpeedUpSim ] [ text "Faster" ]
            ]
        , div [ id "sim_run_state" ]
            [ button [ id "run", onClick Run, disabled (btnState RunButton model) ] [ i [ class "fa fa-play" ] [] ]
            , button [ id "pause", onClick Pause, disabled (btnState PauseButton model) ] [ i [ class "fa fa-pause" ] [] ]
            , button [ id "stop", onClick Finish, disabled (btnState FinishButton model) ] [ i [ class "fa fa-stop" ] [] ]
            ]
        ]


type alias Displayed =
    { name : String, rounding : Int, value : Float, units : String }


makeResult : String -> Int -> Float -> String -> Html Msg
makeResult label rounding value units =
    div [ class "result_box" ]
        [ p [ class "label" ] [ text label ]
        , p [ class "value" ] [ text (Round.round rounding value), span [ class "units" ] [ text units ] ]
        ]


circulationView : Model -> Html Msg
circulationView model =
    let
        p =
            model.patient

        displayed =
            [ Displayed "Pa" 0 p.pa "mmHg"
            , Displayed "Pv" 1 p.pv "mmHg"
            , Displayed "Pra" 1 p.pra "mmHg"
            , Displayed "Ca" 5 p.ca ""
            , Displayed "Cv" 4 p.cv ""
            , Displayed "Cra" 3 p.cra ""
            , Displayed "Va" 2 p.va "L"
            , Displayed "Vv" 2 p.vv "L"
            , Displayed "Vra" 2 p.vra "L"
            , Displayed "Vae" 3 p.vae "mmHg"
            , Displayed "Vve" 3 p.vve "mmHg"
            , Displayed "Vrae" 3 p.vrae "mmHg"
            , Displayed "Va0" 0 p.va0 "mmHg"
            , Displayed "Vv0" 1 p.vv0 "mmHg"
            , Displayed "Vra0" 1 p.vra0 "mmHg"
            , Displayed "Fa" 1 p.fa "L/min"
            , Displayed "Fc" 1 p.fc "L/min"
            , Displayed "Fv" 1 p.fv "L/min"
            , Displayed "Fan" 1 p.fan "L/min"
            , Displayed "Ra" 2 p.ra ""
            , Displayed "Rv" 2 p.rv ""
            , Displayed "Pga" 1 p.pga "mmHg"
            , Displayed "Pgv" 1 p.pgv "mmHg"
            , Displayed "HS" 1 p.hs ""
            ]
    in
    div [ class "circulation_container" ]
        (List.map
            (\{ name, rounding, value, units } -> makeResult name rounding value units)
            displayed
        )


circulationControlsView model =
    div [ id "sliders_and_values" ]
        [ div [ id "hs_slider", class "slide_wrapper" ]
            [ input
                [ class "slider"
                , type_ "range"
                , Attr.min "0"
                , Attr.max "10"
                , Attr.step "1"
                , value <| Round.round 1 (model.patient.hs * 10)
                , onInput HSUpdate
                ]
                []
            ]
        , div
            [ id "hs_slider_value" ]
            [ text <| Round.round 1 model.patient.hs ]
        ]


audioView model =
    div [ id "audio" ]
        [ audio
            [ id "pulse-beep"
            , src "short-beep.mp3"
            , controls False
            ]
            []
        ]
