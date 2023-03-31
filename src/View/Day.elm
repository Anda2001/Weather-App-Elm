module View.Day exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (..)
import Util.Time exposing (Date)


{-| Don't modify
-}
type alias DailyData =
    { date : Date
    , highTemp : Maybe Float
    , lowTemp : Maybe Float
    , totalPrecipitaion : Float
    }


{-| Generates Html based on `DailyData`

Some relevant functions:

  - `Util.Time.formatDate`

-}
view : DailyData -> Html msg
view data =
    -- div [] []
    -- Debug.todo "Implement View.Day.view"
    div [ class "day" ]
        [ div [ class "day-date" ] [ text (Util.Time.formatDate data.date) ]
        , div [ class "day-hightemp" ] 
        [ text 
           <|
           case data.highTemp of 
              Nothing -> "unavailable"
              _ -> (String.fromFloat (Maybe.withDefault 0 data.highTemp)) 
        ]
        , div [ class "day-lowtemp" ] --[ text (String.fromFloat (Maybe.withDefault 0 data.lowTemp)) ]
        [ text 
           <|
           case data.lowTemp of 
              Nothing -> "unavailable"
              _ -> (String.fromFloat (Maybe.withDefault 0 data.lowTemp)) 
        ]
        , div [ class "day-precipitation" ] [ text (String.fromFloat data.totalPrecipitaion) ]

        ]
        
    