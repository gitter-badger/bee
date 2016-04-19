module Map where

import Html exposing (..)
import Html.Attributes exposing (..)

import Sprite exposing (..)

-- Model

(fullMapWidth, fullMapHeight) = (288, 288)
(width, height) = (224, 224)
(halfWidth, halfHeight) = (width/2, height/2)

overflowWidth = fullMapWidth - width
overflowHeight = fullMapHeight - height

-- The model contains the starting coordinates
-- of the visible part of the map
type alias Model =
  { top : Int
  , left : Int
  }

init : Model
init = { top = round -(overflowHeight/2), left= round -(overflowWidth/2) }

-- Update
type Action = VerticalScroll Int
            | HorizontalScroll Int

update : Action -> Model -> Model
update action model =
  case action of
    VerticalScroll i ->
      { model | top = clamp -overflowHeight 0 (model.top + i) }
    HorizontalScroll i ->
      { model | left = clamp -overflowWidth 0 (model.left - i) }

-- View

row : List Html -> Html
row divs =
   div [style [("height",  "32px")]] divs

column : List Html -> Html
column divs =
   div [] divs

fullMap : Model ->Html
fullMap model =
  let _ = Debug.watch "(top, left)" (model.top, model.left)
   in div
  [ style
      [ ("width", (toString fullMapWidth) ++ "px")
      , ("height", (toString fullMapHeight) ++ "px")
      , ("position", "relative")
      , ("top", (toString model.top) ++ "px")
      , ("left", (toString model.left) ++ "px")
      ]
  ]
  [ column
    [ (row [grass1, grass1, grass2, grass1, grass2, rightDirt, dirt, leftDirt, grass1])
    , (row [dirt, dirt, dirt, dirt, dirt, dirt, dirt, leftDirt, grass1])
    , (row [grass1, grass2, grass1, grass2, grass1, rightDirt, dirt, leftDirt, grass2])
    , (row [grass2, grass1, grass2, grass1, grass2, rightDirt, dirt, leftDirt, grass1])
    , (row [grass1, grass2, grass1, grass2, grass1, rightDirt, dirt, leftDirt, grass2])
    , (row [grass2, grass2, grass1, grass2, grass1, rightDirt, dirt, leftDirt, grass1])
    , (row [grass1, grass1, grass1, grass2, grass1, rightDirt, dirt, dirt, dirt])
    , (row [grass2, grass1, grass1, grass2, grass1, rightDirt, dirt, leftDirt, grass2])
    , (row [grass2, grass1, grass1, grass2, grass1, grass2, topDirt, grass1, grass2])
    ]
  ]

view : Model -> Html
view model = div
  [ style
      [ ("width", (toString width) ++ "px")
      , ("height", (toString height) ++ "px")
      , ("overflow", "hidden")
      , ("border", "2px solid black")
      ]
  ]
  [ fullMap model ]
