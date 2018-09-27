module Main exposing (main)

import Browser
import Model exposing (Model, Msg(..), init)
import Subscriptions
import Update
import View


main =
    Browser.element
        { init = Model.init
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        , view = View.view
        }
