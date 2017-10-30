module Types exposing (Model, RepoWrapper, Repo)


type alias Model =
    { content : RepoWrapper
    , inputValue : String
    }


type alias RepoWrapper =
    { total_count : Int
    , items : List Repo
    }


type alias Repo =
    { id : Int
    , name : String
    , html_url : String
    , stargazers_count : Int
    }
