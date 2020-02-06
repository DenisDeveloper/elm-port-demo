module Main exposing (main)

import Browser as B
import Browser.Dom as Dom exposing (Viewport, Element, getViewportOf, getViewport, getElement)
import Html as H exposing (Html, div, text)
import Html.Attributes as Attr exposing (width, height, style, class)
import Task
import String as Str

import Ports

type alias Model =
  { viewportWidth : Int
  , viewportHeight : Int
  , charSize : Float
  , error : List String
  , firstRender : Bool
  }

initModel : Model
initModel =
    { viewportWidth = 0
    , viewportHeight = 0
    , charSize = 0.0
    , error = []
    , firstRender = True
    }

type Msg
  = GotBoundary (Result Dom.Error Dom.Element)
  | FirstRender
  | Noop


viewport = "time-table-view"

getBoundary : Cmd Msg
getBoundary =
  Task.attempt GotBoundary <| getElement viewport

viewportWidth : Result Dom.Error Element -> Float
viewportWidth v =
  case v of
    Err err -> 0
    Ok value ->  .width << .element <| value

viewportHeight : Result Dom.Error Element -> Float
viewportHeight v =
  case v of
    Err err -> 0
    Ok value -> .height << .element <| value

init : Float -> (Model, Cmd Msg)
init flg =
  ({initModel| charSize = flg}, Cmd.none)

main : Program Float Model Msg
main =
  let
    _ = Debug.log "main" "render"
  in
    B.element
      { init = init
      , update = update
      , subscriptions = subscriptions
      , view = view
      }

subscriptions : Model -> Sub Msg
subscriptions model =
  let
    _ = Debug.log "sub" model.firstRender
  in
    Ports.firstRender (\v -> FirstRender)
    -- Sub.none
  -- onResize (\_ _ -> OnPageResize)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    _ = Debug.log "update" model.viewportWidth
  in
  case msg of
    Noop ->
      let
        _ = Debug.log "Noop" ""
      in
        (model, Cmd.none)
    FirstRender ->
      let
        _ = Debug.log "[foo]" ""
      in
        ({model | firstRender = False}, getBoundary)
    GotBoundary v ->
      let
        w = viewportWidth v
        h = viewportHeight v
        _ = Debug.log "v" v
      in
        ( { model |
            viewportWidth = round w
          , viewportHeight = round h
          }
        ,
          Cmd.none
        )

tView =
  div [ class "time-table"]
      [ div [class "ord axis"] [text "2270030030"]
      , div [Attr.id "time-table-view"] []
      ]


view : Model -> Html Msg
view model =
  div [Attr.id "entry"]
  [ H.main_ []
    [ tView ]
  ]
