module Util exposing (groupBy, maximumBy, maybeToList, minimumBy, zipFilter)

{-| Module containing utility functions
-}


{-| Description for minimumBy

    minimumBy .x [ { x = 1, y = 2 } ] --> Just {x = 1, y = 2}

    minimumBy .x [] --> Nothing

    minimumBy (modBy 10) [ 16, 23, 14, 5 ] --> Just 23

-}
minimumBy : (a -> comparable) -> List a -> Maybe a
minimumBy comp lst =
    -- Debug.todo "Implement Util.minimumBy"
    case lst of
        [] ->
            Nothing

        x :: xs ->
            Just (List.foldl (\a b -> if comp a < comp b then a else b) x xs)



{-| Description for maximumBy

    maximumBy .x [ { x = 1, y = 2 } ] --> Just {x = 1, y = 2}

    maximumBy .x [] --> Nothing

    maximumBy (modBy 10) [ 16, 23, 14, 5 ] --> Just 16

-}
maximumBy : (a -> comparable) -> List a -> Maybe a
maximumBy comp l =
    -- Debug.todo "Implement Util.maximumBy"
    case l of
        [] ->
            Nothing

        x :: xs ->
            Just (List.foldl (\a b -> if comp a > comp b then a else b) x xs)


{-| Group a list

    groupBy .x [ { x = 1 } ] --> [(1, [{x = 1}])]

    groupBy (modBy 10) [ 11, 12, 21, 22 ] --> [(1, [11, 21]), (2, [12, 22])]

    groupBy identity [] --> []
-}
groupBy : (a -> b) -> List a -> List ( b, List a )
groupBy cond l =
    -- Debug.todo "Implement Util.groupBy"
    case l of
        [] ->
            []

        x :: xs ->
            let
                (ys, zs) =
                    List.partition (\y -> cond y == cond x) xs
            in
                ( cond x, x :: ys ) :: groupBy cond zs
   


{-| Transforms a Maybe into a List with one element for Just, and an empty list for Nothing

    maybeToList (Just 1) --> [1]

    maybeToList Nothing --> []

-}
maybeToList : Maybe a -> List a
maybeToList a =
    -- Debug.todo "Implement Util.maybeToList"
    case a of
        Just x -> [x]
        Nothing -> []


{-| Filters a list based on a list of bools

    zipFilter [ True, True ] [ 1, 2 ] --> [1, 2]

    zipFilter [ False, False ] [ 1, 2 ] --> []

    zipFilter [ True, False, True, False ] [ 1, 2, 3, 4 ] --> [1, 3]

-}
zipFilter : List Bool -> List a -> List a
zipFilter boolList lst =
    -- Debug.todo "Implement Util.zipFilter"
    let
        filterHelper bools l =
            case (bools, l) of
                ([], []) -> []
                (b::bs, x::xs) ->
                    if b then
                        x :: filterHelper bs xs
                    else
                        filterHelper bs xs
                _ -> []
    in
        filterHelper boolList lst
