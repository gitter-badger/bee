module Main (..) where

import Keyboard
import Time exposing (..)
import Window
import Html exposing (..)
import Html.Attributes exposing (..)
import Sprite exposing (..)
import Map exposing (..)


-- MODEL


type alias Model =
  { x : Float
  , y : Float
  , vx : Float
  , vy : Float
  , dir : String
  , orientation : String
  , sprite : Int
  , map : Map.Model
  }


initialModel : Model
initialModel =
  Model halfWidth halfHeight 0 0 "left" "toward" 0 Map.init



-- UPDATE


update : ( Time, { x : Int, y : Int }, Bool ) -> Model -> Model
update ( timeDelta, direction, isRunning ) model =
  model
    |> newVelocity isRunning direction
    |> setDirection direction
    |> updatePosition timeDelta
    |> updateMap timeDelta
    |> updateSprite


updateSprite : Model -> Model
updateSprite ({ sprite } as model) =
  let
    newSprite =
      if sprite == 0 then
        1
      else
        0
  in
    { model
      | sprite = newSprite
    }


newVelocity : Bool -> { x : Int, y : Int } -> Model -> Model
newVelocity isRunning { x, y } model =
  let
    scale =
      if isRunning then
        4
      else
        2

    newVel n =
      if x == 0 || y == 0 then
        scale * toFloat n
      else
        scale * toFloat n / sqrt 2
  in
    { model
      | vx = newVel x
      , vy = newVel y
    }


setDirection : { x : Int, y : Int } -> Model -> Model
setDirection { x, y } model =
  { model
    | orientation =
        if y < 0 then
          "toward"
        else if y > 0 then
          "away"
        else
          model.orientation
    , dir =
        if x > 0 then
          "right"
        else if x < 0 then
          "left"
        else
          model.dir
  }


updatePosition : Time -> Model -> Model
updatePosition dt ({ x, y, vx, vy } as model) =
  { model
    | x = clamp 0 (Map.width - 32) (x + dt * vx)
    , y = clamp 32 Map.height (y + dt * vy)
  }


updateMap : Time -> Model -> Model
updateMap dt ({ x, y, vx, vy, map } as model) =
  let
    ( bottom, left, right, top ) =
      ( 0, 0, Map.width, Map.height )

    ( movingUp, movingDown, movingRight, movingLeft ) =
      ( vy > 0, vy < 0, vx > 0, vx < 0 )

    action : Map.Action
    action =
      if x == left && movingLeft then
        Map.HorizontalScroll (round (dt * vx))
      else if (x + 32) == right && movingRight then
        Map.HorizontalScroll (round (dt * vx))
      else if y == top && movingUp then
        Map.VerticalScroll (round (dt * vy))
      else if (y - 32) == bottom && movingDown then
        Map.VerticalScroll (round (dt * vy))
      else
        Map.HorizontalScroll 0
  in
    { model
      | map = Map.update action map
    }



-- VIEW


view : ( Int, Int ) -> Model -> Html
view ( w, h ) ({ x, y, vx, vy, dir, sprite } as model) =
  let
    bee =
      viewBee model

    -- outer, middle, inner is for vertical & horizontal centering
    outer =
      div
        [ style
            [ ( "display", "table" )
            , ( "position", "absolute" )
            , ( "height", "100%" )
            , ( "width", "100%" )
            ]
        ]
        [ middle ]

    middle =
      div
        [ style
            [ ( "display", "table-cell" )
            , ( "vertical-align", "middle" )
            ]
        ]
        [ inner ]

    inner =
      div
        [ style
            [ ( "margin-left", "auto" )
            , ( "margin-right", "auto" )
            , ( "width", (toString Map.width) ++ "px" )
            ]
        ]
        [ Map.view model.map, bee ]
  in
    outer


viewBee : Model -> Html
viewBee { x, y, vx, vy, dir, orientation, sprite } =
  let
    beeImage =
      case ( dir, orientation, sprite ) of
        ( "left", "toward", 0 ) ->
          southWestBee1

        ( "left", "toward", 1 ) ->
          southWestBee2

        ( "left", "away", 0 ) ->
          northWestBee1

        ( "left", "away", 1 ) ->
          northWestBee2

        ( "right", "toward", 0 ) ->
          southEastBee1

        ( "right", "toward", 1 ) ->
          southEastBee2

        ( "right", "away", 0 ) ->
          northEastBee1

        ( "right", "away", 1 ) ->
          northEastBee2

        ( _, _, _ ) ->
          southWestBee1
  in
    div
      [ style
          [ ( "width", "32px" )
          , ( "height", "32px" )
          , ( "position", "relative" )
          , ( "top", "-" ++ (toString y) ++ "px" )
          , ( "left", (toString x) ++ "px" )
          ]
      ]
      [ beeImage ]



-- SIGNALS


main : Signal Html
main =
  Signal.map2 view Window.dimensions (Signal.foldp update initialModel input)


input : Signal ( Time, { x : Int, y : Int }, Bool )
input =
  Signal.sampleOn delta (Signal.map3 (,,) delta Keyboard.arrows Keyboard.shift)


delta : Signal Time
delta =
  Signal.map (\t -> t / 20) (fps 25)
