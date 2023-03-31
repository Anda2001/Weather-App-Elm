module Main exposing (..)

import Browser
import Chart.Item as CI
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Http
import Model exposing (Config, Mode(..), Model, Weather)
import Model.WeatherData as WeatherData exposing (ApiWeatherData, HourlyDataPoint)
import Model.WeatherItems exposing (SelectedWeatherItems, WeatherItem(..))
import Task
import Time
import Url.Builder as UrlBuilder
import Util
import Util.Time
import View.WeatherChart exposing (showAllItems)
import View.WeatherItems
import View.Week
import View.WeatherChart exposing (ShownItems)
import Time
import View.WeatherChart exposing (ChartData)
import View.Day exposing (DailyData)
import Time exposing (Posix)
import View.WeatherChart exposing (Hovering)
import View.WeatherChart
import Model.WeatherItems
import Model.WeatherItems exposing (weatherItems)
import Model.WeatherItems
import Model.WeatherItems exposing (allSelected)
import View.Week exposing (WeeklyData)


{-| Don't modify
-}
type Msg
    = GotTime Time.Posix
    | GetWeather
    | GotWeather (Result Http.Error ApiWeatherData)
    | OnHover (List (CI.One HourlyDataPoint CI.Dot))
    | ChangeWeatherItemSelection WeatherItem Bool


prodFlags : Config
prodFlags =
    { apiUrl = "https://api.open-meteo.com", mode = Prod }


devFlags : Config
devFlags =
    { apiUrl = "http://localhost:3000", mode = Dev }


{-| Create a program that uses the "production" configuration (uses the real API to get the weather data)
-}
main : Program () Model Msg
main =
    Browser.element
        { init = init prodFlags
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


{-| Create a program that uses the development configuration (uses the local server to get the weather data)
-}
reactorMain : Program () Model Msg
reactorMain =
    Browser.element
        { init = init devFlags
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


{-| Don't modify
-}
init : Config -> () -> ( Model, Cmd Msg )
init flags _ =
    ( Model.initModel flags
    , Task.perform GotTime Time.now
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getWeather : String -> Cmd Msg
getWeather apiUrl =
    let
        queryParams =
            List.concat
                [ [ UrlBuilder.string "latitude" <| String.fromFloat 46.77
                  , UrlBuilder.string "longitude" <| String.fromFloat 23.6
                  , UrlBuilder.string "timezone" "auto"
                  , UrlBuilder.string "timeformat" "unixtime"
                  ]
                , List.map (UrlBuilder.string "hourly")
                    [ "temperature_2m"
                    , "precipitation"
                    ]
                ]
    in
    Http.get
        { url = UrlBuilder.crossOrigin apiUrl [ "v1", "forecast" ] queryParams
        , expect = Http.expectJson GotWeather WeatherData.decodeWeatherData
        }


adjustTime : Int -> Time.Posix -> Time.Posix
adjustTime offset time =
    time |> Time.posixToMillis |> (\m -> m + 1000 * offset) |> Time.millisToPosix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newState, cmd ) =
            case ( msg, model.state ) of
                ( GotTime time, _ ) ->
                    ( Model.HaveTime { time = time }
                    , getWeather model.config.apiUrl
                    )

                ( GotWeather res, Model.HaveTime state ) ->
                    case res of
                        Ok weather ->
                            ( Model.HaveWeatherAndTime
                                { time = adjustTime weather.utcOffset state.time
                                , weather = weather
                                , hovering = []
                                , selectedItems = Model.WeatherItems.allSelected
                                }
                            , Cmd.none
                            )

                        Err err ->
                            ( Model.FailedToLoad, Cmd.none )

                ( OnHover hovering, Model.HaveWeatherAndTime data ) ->
                    ( Model.HaveWeatherAndTime { data | hovering = hovering }, Cmd.none )

                ( ChangeWeatherItemSelection item newValue, Model.HaveWeatherAndTime data ) ->
                    --  ( model.state, Cmd.none )
                    (Model.HaveWeatherAndTime { data | selectedItems  = Model.WeatherItems.set item newValue data.selectedItems}, Cmd.none)
                   -- Debug.todo "Handle the ChangeWeatherItemSelection message in update"
                   


                ( GetWeather, _ ) ->
                    ( model.state, getWeather model.config.apiUrl )
    
                    

                _ ->
                    ( model.state, Cmd.none )
    in
    ( { model | state = newState }, cmd )


{-| Derive (extract) the data required for the weather chart from the state of the app

Some relevant functions:

  - `WeatherData.toHourlyDataPoints`
  - `Util.minimumBy`, `Util.maximumBy`

-}
getChartData : Weather -> View.WeatherChart.ChartData
getChartData weatherData =
    -- Debug.todo "getChartData"
    let
        now = weatherData.time
        hourlyDataPoints =
            WeatherData.toHourlyDataPoints weatherData.weather

        minTemp =
            Util.minimumBy .temperature hourlyDataPoints
        maxTemp =
            Util.maximumBy .temperature hourlyDataPoints
        hovering = 
            weatherData.hovering
        itemsToShow =
            weatherData.selectedItems
    in
    { now = now,
        minTempPoint = minTemp,
        maxTempPoint = maxTemp,
        hourlyPoints = hourlyDataPoints,
        hovering = hovering,
        itemsToShow = itemsToShow
    }


{-| Derive (extract) the data required for the weather chart from the state of the app
Some relevant functions:

  - `WeatherData.toHourlyDataPoints`
  - `List.minimum`, `List.maximum`
  - `Util.Time.posixToDate`

-}
getWeeklyData : Weather -> View.Week.WeeklyData
getWeeklyData weatherData =
   --Debug.todo "getWeeklyData"
--    let
--         split i list = 
--             case List.take i list of
--                 [] -> []
--                 listHead -> listHead :: split i (List.drop i list)
--         data = WeatherData.toHourlyDataPoints weatherData.weather
--         chunks = List.reverse <| List.reverse data |> split 24
--         -- for each chunck of 24 hours, get the min and max temperature
--         minTemps = List.map (\x -> Util.minimumBy .temperature x) chunks
--         maxTemps = List.map (\x -> Util.maximumBy .temperature x) chunks
--         -- for each chunck of 24 hours, get the precipitation
--         precipitations = List.map (\x -> List.sum (List.map .precipitation x)) chunks
--         -- for each chunck of 24 hours, get the date
--         dates = List.map (\x -> Util.Time.posixToDate Time.utc weatherData.time) chunks
--         -- for each day, make a daily data
--         dailyData = List.map3(\x y z -> {minTemp = x, maxTemp = y, precipitation = z}) minTemps maxTemps precipitations
--         -- for each day, make a weekly data
     
--     in
--         dailyData
     View.Week.WeeklyData []



view : Model -> Html Msg
view model =
    case model.state of
        Model.FailedToLoad ->
            -- div [] []
            div [] [ text "Failed to load" ]

        Model.WaitingForTime ->
            -- div [] []
            div [] [ text "Obtaining the current time" ]

        Model.HaveTime _ ->
            -- div [] []
            div [] [ text "Loading the weather" ]

        Model.HaveWeatherAndTime data ->
            div []
                [ h1 []
                    [ h1 []
                        [ if model.config.mode == Model.Dev then
                            text "Weather (DEV)"

                          else
                            text "Weather"
                        ]
                    ]
                --,
                -- Debug.todo "Add View.WeatherItems.view"
                --html msg
                , View.WeatherItems.view { onChangeSelection = ChangeWeatherItemSelection } data.selectedItems

                -- Comment to make the code compile
                , View.WeatherChart.view { onHover = OnHover } (getChartData data) -- Comment to prevent crash if getChartData is not implemented
                , View.Week.view (getWeeklyData data) -- Comment to prevent crash if getWeeklyData is not implemented
                ]
