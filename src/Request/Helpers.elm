module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl =
    (++) "/elm-pageloader-demo-site/static"
