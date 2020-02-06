port module Ports exposing (scrollTo, firstRender)

port scrollTo : String -> Cmd msg

port firstRender : (Bool -> msg) -> Sub msg
