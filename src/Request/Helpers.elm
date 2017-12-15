module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl =
    (++) "/src/static"
