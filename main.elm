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
  , sprite : Int
  }


hero : Model
hero =
  Model 0 0 0 0 "north" 0


-- UPDATE

update : (Time, { x:Int, y:Int }, Bool) -> Model -> Model
update (timeDelta, direction, isRunning) model =
  model
    |> newVelocity isRunning direction
    |> setDirection direction
    |> updatePosition timeDelta
    |> updateSprite


updateSprite : Model -> Model
updateSprite ({sprite} as model) =
  let newSprite = if sprite == 0 then 1 else 0
   in { model |
        sprite = newSprite
      }

newVelocity : Bool -> { x:Int, y:Int } -> Model -> Model
newVelocity isRunning {x,y} model =
  let
    scale =
      if isRunning then 2 else 1

    newVel n =
      if x == 0 || y == 0 then
        scale * toFloat n
      else
        scale * toFloat n / sqrt 2
  in
      { model |
          vx = newVel x,
          vy = newVel y
      }


setDirection : { x:Int, y:Int } -> Model -> Model
setDirection {x,y} model =
  { model |
      dir =
        if x > 0 then
            "east"

        else if x < 0 then
            "west"

        else if y < 0 then
            "south"

        else if y > 0 then
            "north"

        else
            model.dir
  }


updatePosition : Time -> Model -> Model
updatePosition dt ({x,y,vx,vy} as model) =
  { model |
      x = clamp 0 (mapWidth-32) (x + dt * vx),
      y = clamp 32 mapHeight (y + dt * vy)
  }


-- VIEW


view : (Int,Int) -> Model -> Html
view (w,h) ({x,y,vx,vy,dir,sprite} as model) =
  let
    bee = viewBee model
    -- outer, middle, inner is for vertical & horizontal centering
    outer =
      div
        [ style
          [ ("display", "table")
          , ("position", "absolute")
          , ("height", "100%")
          , ("width", "100%")
          ]
        ]
        [middle]

    middle =
      div
        [ style
          [ ("display", "table-cell")
          , ("vertical-align", "middle")
          ]
        ]
        [inner]

    inner =
      div
        [ style
          [ ("margin-left", "auto")
          , ("margin-right", "auto")
          , ("width", (toString mapWidth) ++ "px")
          ]
        ]
        [map, bee]
  in
    outer

viewBee : Model -> Html
viewBee {x,y,vx,vy,dir,sprite} =
  let
    beeImage =
      case (dir, sprite) of
            ("north", 0) -> northBee1
            ("north", 1) -> northBee2
            ("south", 0) -> southBee1
            ("south", 1) -> southBee2

            ("east", 0) -> eastBee1
            ("east", 1) -> eastBee2
            ("west", 0) -> westBee1
            ("west", 1) -> westBee2
            (_, _) -> northBee1
  in
      div
        [ style [ ("width", "32px")
                , ("height", "32px")
                , ("position", "relative")
                , ("top", "-" ++ (toString y) ++ "px")
                , ("left", (toString x) ++ "px")
                ]
        ] [beeImage]


-- SIGNALS

main : Signal Html
main =
  Signal.map2 view Window.dimensions (Signal.foldp update hero input)


input : Signal (Time, { x:Int, y:Int }, Bool)
input =
  Signal.sampleOn delta (Signal.map3 (,,) delta Keyboard.arrows Keyboard.shift)


delta : Signal Time
delta =
  Signal.map (\t -> t / 20) (fps 25)

