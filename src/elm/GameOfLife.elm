module GameOfLife exposing (..)

{-| The logic for conways game of life.
-}

import Set as Set
import Model as Model


{-| Return the indices of all neighbour-cells for a given cell.
A cell always has 8 neighbours.
-}
adjacentCells : ( Int, Int ) -> Model.Model -> Set.Set ( Int, Int )
adjacentCells ( a, b ) model =
    if (a < 0 || b < 0 || a >= model.height || b >= model.width) then
        Set.empty
    else
        Set.map (\x -> mapCellWithBreak x model)
            (Set.fromList
                [ ( a - 1, b - 1 )
                , ( a - 1, b )
                , ( a - 1, b + 1 )
                , ( a, b - 1 )
                , ( a, b + 1 )
                , ( a + 1, b - 1 )
                , ( a + 1, b )
                , ( a + 1, b + 1 )
                ]
            )


{-|Returns true if the passed cell would live in he next round.
-}
livesInNextGeneration : ( Int, Int ) -> Model.Model -> Bool
livesInNextGeneration ( a, b ) model =
    let
        livingNeighbours =
            determineCountOfLivingNeighbours ( a, b ) model
    in
        ((Set.member ( a, b ) model.livingCells) && livingNeighbours == 2) || livingNeighbours == 3


{-|Returns the number of neighbours for a given cell which are currently living
-}
determineCountOfLivingNeighbours : ( Int, Int ) -> Model.Model -> Int
determineCountOfLivingNeighbours ( a, b ) model =
    Set.size (Set.filter (\i -> Set.member i model.livingCells) (adjacentCells ( a, b ) model))


buildAllPossibleCellsInGrid : Model.Model -> Set.Set ( Int, Int )
buildAllPossibleCellsInGrid model =
    Set.fromList (List.concatMap (\i -> List.map (\j -> ( i, j )) (List.range 0 (model.width - 1))) (List.range 0 (model.height - 1)))


{-| Return all living cells for the generation after the state described by the passed model.
-}
determineNextGeneration : Model.Model -> Set.Set ( Int, Int )
determineNextGeneration model =
    Set.filter (\i -> livesInNextGeneration i model) (buildAllPossibleCellsInGrid model)


{-|Utility method to handle overflows of cells transparently.
I.e. if you exceed the bord to the right you start again on the left side.
-}
mapCellWithBreak : ( Int, Int ) -> Model.Model -> ( Int, Int )
mapCellWithBreak ( a, b ) model =
    ( mapCellComponentWithBreak a model.height, mapCellComponentWithBreak b model.width )


{-|Utility method to handle overflows of cells transparently.
I.e. if you exceed the bord to the right you start again on the left side.
-}
mapCellComponentWithBreak : Int -> Int -> Int
mapCellComponentWithBreak input breakAt =
    if (input < 0) then
        breakAt - 1
    else if (input >= breakAt) then
        0
    else
        input