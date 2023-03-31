module View.WeatherItems exposing (view)

import Html exposing (..)
import Html.Attributes as HA exposing (class, style)
import Html.Events exposing (..)
import Model.WeatherItems exposing (SelectedWeatherItems, WeatherItem(..))
import View.WeatherChart exposing (ShownItems)
import Model.WeatherItems exposing (allSelected)


checkbox : String -> Bool -> (WeatherItem -> Bool -> msg) -> WeatherItem -> Html msg
checkbox name state msg category =
    div [ style "display" "inline", class "checkbox" ]
        [ input [ HA.type_ "checkbox", onCheck (msg category), HA.checked state ] []
        , text name
        ]


type alias MsgMap msg =
    { onChangeSelection : WeatherItem -> Bool -> msg }


view : MsgMap msg -> SelectedWeatherItems -> Html msg
view msg selected =
    -- div [] []
    -- Debug.todo "view"
    -- div [] [ text "TODO" ]
    --make 4 checkboxes
    
    div []
        [ checkbox "Temperature" (selected.temperature) msg.onChangeSelection Temperature
        , checkbox "Precipitation" (selected.precipitation) msg.onChangeSelection Precipitation
        , checkbox "MinMax" (selected.minMax) msg.onChangeSelection MinMax
        , checkbox "CurrentTime" (selected.currentTime) msg.onChangeSelection CurrentTime
        ]

        