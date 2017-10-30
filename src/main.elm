module Main exposing (..)

import Html exposing (Html, input, text, button, div, ul, li)
import Html.Attributes exposing (disabled, placeholder, value, style)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Events exposing (..)
import Types exposing (Model, RepoWrapper, Repo)
import DomHelpers exposing (toDomList)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }


defaultModel : Model
defaultModel =
    { content =
        { total_count = 0
        , items = []
        }
    , inputValue = ""
    }


decodeRepos : Decode.Decoder RepoWrapper
decodeRepos =
    Decode.map2 RepoWrapper
        (Decode.field "total_count" Decode.int)
        (Decode.field "items"
            (Decode.list
                (Decode.map4 Repo
                    (Decode.field "id" Decode.int)
                    (Decode.field "name" Decode.string)
                    (Decode.field "html_url" Decode.string)
                    (Decode.field "stargazers_count" Decode.int)
                )
            )
        )


getRepos : String -> Cmd Msg
getRepos lang =
    let
        url =
            "https://api.github.com/search/repositories?q=language:" ++ lang
    in
        Http.send FetchReposFulfilled (Http.get url decodeRepos)


init : ( Model, Cmd Msg )
init =
    ( defaultModel, getRepos "elm" )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchRepos lang ->
            ( model, getRepos lang )

        FetchReposFulfilled (Ok response) ->
            ( { model | content = response }, Cmd.none )

        FetchReposFulfilled (Err _) ->
            ( defaultModel, Cmd.none )

        ChangeInputText text ->
            ( { model
                | inputValue = text
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ style [ ( "padding", "20px" ) ] ]
        [ input
            [ placeholder "Search by Programming Language"
            , onInput ChangeInputText
            , value model.inputValue
            , style [ ( "padding", "4px" ) ]
            ]
            []
        , button
            [ onClick (FetchRepos model.inputValue)
            , disabled (String.length model.inputValue == 0)
            , style
                [ ( "padding", "5px 8px" )
                , ( "margin-left", "5px" )
                , ( "cursor", "pointer" )
                ]
            ]
            [ Html.text "Search" ]
        , div [] [ toDomList model.content ]
        ]
