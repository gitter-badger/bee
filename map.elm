module Map (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Sprite exposing (..)


-- Model
-- TODO: figure out comment formatting
{- The model contains the starting coordinates
-- of the visible part of the map
-}


type alias Model =
  { top : Int
  , left : Int
  }


( fullMapWidth, fullMapHeight ) =
  ( 288, 288 )


( width, height ) =
  ( 224, 224 )


( halfWidth, halfHeight ) =
  ( width / 2, height / 2 )


overflowWidth =
  fullMapWidth - width


overflowHeight =
  fullMapHeight - height


init : Model
init =
  { top = round -(overflowHeight / 2)
  , left = round -(overflowWidth / 2)
  }



-- Update


type Action
  = VerticalScroll Int
  | HorizontalScroll Int


update : Action -> Model -> Model
update action model =
  case action of
    VerticalScroll i ->
      { model | top = clamp -overflowHeight 0 (model.top + i) }

    HorizontalScroll i ->
      { model | left = clamp -overflowWidth 0 (model.left - i) }



-- View


view : Model -> Html
view model =
  div
    [ style
        [ ( "width", (toString width) ++ "px" )
        , ( "height", (toString height) ++ "px" )
        , ( "overflow", "hidden" )
        , ( "border", "2px solid black" )
        ]
    ]
    [ fullMap model ]


fullMap : Model -> Html
fullMap model =
  let
    _ =
      Debug.watch "(top, left)" ( model.top, model.left )
  in
    div
      [ style
          [ ( "width", (toString fullMapWidth) ++ "px" )
          , ( "height", (toString fullMapHeight) ++ "px" )
          , ( "position", "relative" )
          , ( "top", (toString model.top) ++ "px" )
          , ( "left", (toString model.left) ++ "px" )
          ]
      ]
      [ column
          [ (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ horzPath, horzPath, horzPath, horzPath, horzPath, horzPath, crossPath, horzPath, horzPath ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          , (row [ grass, grass, grass, grass, grass, grass, vertPath, grass, grass ])
          ]
      ]


row : List Html -> Html
row divs =
  div [ style [ ( "height", "32px" ) ] ] divs


column : List Html -> Html
column divs =
  div [] divs
