module Map where

import Html exposing (..)
import Html.Attributes exposing (..)

import Sprite exposing (..)

(mapWidth, mapHeight) = (160, 160)
(halfMapWidth, halfMapHeight) = (mapWidth/2, mapHeight/2)

row : List Html -> Html
row divs =
   div [style [("height",  "32px")]] divs

column : List Html -> Html
column divs =
   div [] divs

map : Html
map = div
  [ style
      [ ("width", (toString mapWidth) ++ "px")
      , ("height", (toString mapHeight) ++ "px")
      ]
  ]
  [ column
    [ (row [grass1, grass2, rightDirt, dirt, leftDirt])
    , (row [dirt, dirt, dirt, dirt, leftDirt])
    , (row [grass2, grass1, rightDirt, dirt, leftDirt])
    , (row [grass1, grass2, rightDirt, dirt, leftDirt])
    , (row [grass2, grass1, rightDirt, dirt, leftDirt])
    ]
  ]
