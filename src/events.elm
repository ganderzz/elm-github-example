module Events exposing (Msg(..))

import Http
import Types exposing (..)


type Msg
    = ChangeInputText String
    | FetchRepos String
    | FetchReposFulfilled (Result Http.Error RepoWrapper)
