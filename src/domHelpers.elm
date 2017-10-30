module DomHelpers exposing (toDomList)

import Html exposing (Html, ul, li, a)
import Html.Attributes exposing (style, href)
import Events exposing (Msg)
import Types exposing (RepoWrapper)


toDomList : RepoWrapper -> Html Msg
toDomList entry =
    ul []
        (List.map
            (\item ->
                li
                    [ style [ ( "cursor", "pointer" ), ( "padding", "3px" ) ]
                    ]
                    [ a [ href item.html_url ]
                        [ Html.text <| item.name ++ " (Stars: " ++ (toString item.stargazers_count) ++ ")"
                        ]
                    ]
            )
            entry.items
        )
