module Sprite where

import Html exposing (..)
import Html.Attributes exposing (..)

imgFromSpriteSheet : String -> (Int,Int) -> Html
imgFromSpriteSheet spriteSheet (x,y) =
  img [ src "empty.png"
      , style [ ("width", "32px")
              , ("height", "32px")
              , ("background-image", "url(" ++ spriteSheet ++ ")")
              , ("background-position",
                "-"++(toString x) ++ "px -" ++ (toString y) ++ "px")
              ]
      ] []

-- Bee Sprite

beeFromSpriteSheet =
  imgFromSpriteSheet "bee4.png"

northBee1 = beeFromSpriteSheet (0,0)
northBee2 = beeFromSpriteSheet (64,0)
southBee1 = beeFromSpriteSheet (0,32)
southBee2 = beeFromSpriteSheet (64,32)

eastBee1 = beeFromSpriteSheet (32,32)
eastBee2 = beeFromSpriteSheet (96,32)
westBee1 = beeFromSpriteSheet (32,0)
westBee2 = beeFromSpriteSheet (96,0)

-- Path Sprite

tileFromSpriteSheet : (Int,Int) -> Html
tileFromSpriteSheet =
  imgFromSpriteSheet "dirtpath.png"


grass1 = tileFromSpriteSheet (0,0)
rightDirt = tileFromSpriteSheet (0,32)
bottomLeftDirt = tileFromSpriteSheet (0,64)

grass2 = tileFromSpriteSheet (32,0)
dirt = tileFromSpriteSheet (32,32)
bottomRightDirt = tileFromSpriteSheet (32,64)

bottomDirt = tileFromSpriteSheet (64,0)
leftDirt = tileFromSpriteSheet (64,32)
topLeftDirt = tileFromSpriteSheet (64,64)

topDirt = tileFromSpriteSheet (96,0)
topRightDirt = tileFromSpriteSheet (96,32)
