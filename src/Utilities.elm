module Utilities exposing (ntimes, secondsInMinute, toMinSec)


secondsInMinute : Float
secondsInMinute =
    60.0


ntimes : Int -> (a -> a) -> a -> a
ntimes n func arg =
    case n of
        1 ->
            func arg

        _ ->
            ntimes (n - 1) func (func arg)


toMinSec : Int -> String
toMinSec seconds =
    let
        m =
            String.fromInt (seconds // 60)

        s =
            remainderBy 60 seconds

        s_pad =
            if s < 10 then
                "0" ++ String.fromInt s

            else
                String.fromInt s
    in
    m ++ ":" ++ s_pad
