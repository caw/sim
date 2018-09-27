module Model exposing (Model, Msg(..), Patient, State(..), UIButton(..), init)

import Time exposing (Posix)
import Utilities exposing (..)


type Msg
    = Tick Time.Posix
    | Run
    | Pause
    | Finish
    | SlowDownSim
    | SpeedUpSim
    | HSUpdate String


type UIButton
    = RunButton
    | PauseButton
    | FinishButton


type alias Model =
    { patient : Patient
    , agenda : Int
    , interventions : Int
    , state : State
    , runningTime : Int
    , speedUp : Float
    , rangeDemo : Int
    }


type State
    = NotStarted
    | Running
    | Paused
    | Finished


initialPatient : Patient
initialPatient =
    patient


initialModel : Model
initialModel =
    { patient = initialPatient
    , agenda = 0
    , interventions = 0
    , state = NotStarted
    , runningTime = 0
    , speedUp = 1.0
    , rangeDemo = 0
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


secondsInMinute : Float
secondsInMinute =
    60.0


type alias Patient =
    { cra : Float
    , ca : Float
    , cv : Float
    , vra : Float
    , va : Float
    , vv : Float
    , vrae : Float
    , vae : Float
    , vve : Float
    , vra0 : Float
    , va0 : Float
    , vv0 : Float
    , fa : Float
    , fan : Float
    , fc : Float
    , fv : Float
    , ra : Float
    , rv : Float
    , pga : Float
    , pgv : Float
    , pa : Float
    , pv : Float
    , pra : Float
    , hs : Float
    }


patient : Patient
patient =
    { cra = 0.005
    , ca = 0.00355
    , cv = 0.0825
    , vra = 0.1
    , va = 0.85
    , vv = 3.25
    , vrae = 0.0
    , vae = 0.355
    , vve = 0.3
    , vra0 = 0.1
    , va0 = 0.495
    , vv0 = 2.95
    , fa = 5.0 / secondsInMinute
    , fc = 5.0 / secondsInMinute
    , fv = 5.0 / secondsInMinute
    , fan = 5.0 / secondsInMinute
    , ra = 19.34 * secondsInMinute
    , rv = 0.74 * secondsInMinute
    , pga = 96.3
    , pgv = 3.7
    , pa = 100.0
    , pv = 3.7
    , pra = 0.0
    , hs = 1.0
    }
