module Sprite (..) where

import Html exposing (..)
import Html.Attributes exposing (..)


imgFromSpriteSheet : String -> ( Int, Int ) -> Html
imgFromSpriteSheet spriteSheet ( x, y ) =
  img
    [ src "empty.png"
    , style
        [ ( "width", "32px" )
        , ( "height", "32px" )
        , ( "background-image", "url(" ++ spriteSheet ++ ")" )
        , ( "background-position"
          , "-" ++ (toString x) ++ "px -" ++ (toString y) ++ "px"
          )
        ]
    ]
    []



-- Bee Sprite


beeFromSpriteSheet =
  imgFromSpriteSheet "newbee.png"


northWestBee1 =
  beeFromSpriteSheet ( 64, 0 )


northWestBee2 =
  beeFromSpriteSheet ( 0, 32 )


northEastBee1 =
  beeFromSpriteSheet ( 0, 0 )


northEastBee2 =
  beeFromSpriteSheet ( 32, 0 )


southWestBee1 =
  beeFromSpriteSheet ( 32, 32 )


southWestBee2 =
  beeFromSpriteSheet ( 64, 32 )


southEastBee1 =
  beeFromSpriteSheet ( 0, 64 )


southEastBee2 =
  beeFromSpriteSheet ( 32, 64 )



-- Path Sprite


tileFromSpriteSheet : ( Int, Int ) -> Html
tileFromSpriteSheet =
  imgFromSpriteSheet "dirtpath.png"


grass1 =
  tileFromSpriteSheet ( 0, 0 )


rightDirt =
  tileFromSpriteSheet ( 0, 32 )


bottomLeftDirt =
  tileFromSpriteSheet ( 0, 64 )


grass2 =
  tileFromSpriteSheet ( 32, 0 )


dirt =
  tileFromSpriteSheet ( 32, 32 )


bottomRightDirt =
  tileFromSpriteSheet ( 32, 64 )


bottomDirt =
  tileFromSpriteSheet ( 64, 0 )


leftDirt =
  tileFromSpriteSheet ( 64, 32 )


topLeftDirt =
  tileFromSpriteSheet ( 64, 64 )


topDirt =
  tileFromSpriteSheet ( 96, 0 )


topRightDirt =
  tileFromSpriteSheet ( 96, 32 )
