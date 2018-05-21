module GameOfLife exposing (..)

import Set as Set
import Model as Model


mapCellComponentWithBreak : Int -> Int -> Int
mapCellComponentWithBreak input breakAt =
    if (input < 0) then
        breakAt - 1
    else if (input >= breakAt) then
        0
    else
        input


mapCellWithBreak : ( Int, Int ) -> Model.Model -> ( Int, Int )
mapCellWithBreak ( a, b ) model =
    ( mapCellComponentWithBreak a model.height, mapCellComponentWithBreak b model.width )


adjacentCells : ( Int, Int ) -> Model.Model -> Set.Set ( Int, Int )
adjacentCells ( a, b ) model =
    if (a < 0 || b < 0 || a >= model.height || b >= model.height) then
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


livesInNextGeneration : ( Int, Int ) -> Model.Model -> Bool
livesInNextGeneration ( a, b ) model =
    let
        livingNeighbours =
            determineCountOfLivingNeighbours ( a, b ) model
    in
        ((Set.member ( a, b ) model.livingCells) && livingNeighbours == 2) || livingNeighbours == 3


determineCountOfLivingNeighbours : ( Int, Int ) -> Model.Model -> Int
determineCountOfLivingNeighbours ( a, b ) model =
    Set.size (Set.filter (\i -> Set.member i model.livingCells) (adjacentCells ( a, b ) model))


buildAllPossibleCellsInGrid : Model.Model -> Set.Set ( Int, Int )
buildAllPossibleCellsInGrid model =
    Set.fromList (List.concatMap (\i -> List.map (\j -> ( i, j )) (List.range 0 (model.width - 1))) (List.range 0 (model.height - 1)))


determineNextGeneration : Model.Model -> Set.Set ( Int, Int )
determineNextGeneration model =
    Set.filter (\i -> livesInNextGeneration i model) (buildAllPossibleCellsInGrid model)
