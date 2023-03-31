module View.Week exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (..)
import Util.Time exposing (Date, formatDate)
import View.Day exposing (DailyData)
import Util.Time exposing (Date)
import Util.Time exposing (Date(..))
import Time


type alias WeeklyData =
    { dailyData : List DailyData
    }


{-| Generates Html based on `WeeklyData`

Some relevant functions:

  - `Util.Time.formatDate`

-}
view : WeeklyData -> Html msg
view data =
    -- div [] []
    -- Debug.todo "Implement View.Week.view"
    -- div [ class "week" ]
    --     [ div [ class "day" ]
    --         [ div [ class "date" ] [ text "Mon 1" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --     , div [ class "day" ]
    --         [ div [ class "date" ] [ text "Tue 2" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --     , div [ class "day" ]
    --         [ div [ class "date" ] [ text "Wed 3" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --     , div [ class "day" ]
    --         [ div [ class "date" ] [ text "Thu 4" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --     , div [ class "day" ]
    --         [ div [ class "date" ] [ text "Fri 5" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --     , div [ class "day" ]
    --         [ div [ class "date" ] [ text "Sat 6" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --     , div [ class "day" ]
    --         [ div [ class "date" ] [ text "Sun 7" ]
    --         , div [ class "weather" ] [ text "☀️" ]
    --         , div [ class "temp" ] [ text "20" ]
    --         ]
    --   ]
    -- div [ class "week" ]
    --     (List.map View.Day.view data.dailyData)
    --The dates of the first and last day should be displayed in a h2 element

    let
        firstDay =
            data.dailyData
                |> List.head
                |> Maybe.map .date
                |> Maybe.withDefault (Date {year = 2022, month = Time.Jan, day = 1})

        lastDay =
            data.dailyData
                |> List.reverse
                |> List.head
                |> Maybe.map .date
                |> Maybe.withDefault (Date {year = 2022, month = Time.Jan, day = 1})


        func =
            [ h2 [] [ text <| formatDate firstDay ++ " - " ++ formatDate lastDay ] ]
               ++ (List.map View.Day.view data.dailyData)
    in
    div [ class "week" ]
        (func)


