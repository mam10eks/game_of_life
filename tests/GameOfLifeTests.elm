module GameOfLifeTests exposing (..)

import Model exposing (..)
import GameOfLife
import Expect as Expect
import Test as Test
import Set as Set

firstExampleTestSuite : Test.Test
firstExampleTestSuite =
    Test.describe "Example Test suite to learn unit testing with elm" [
        Test.test "Test reverse has no effect on a palindrome" <| \_ -> Expect.equal "HannaH" (String.reverse "HannaH")

        , Test.test "Check that reverse of 'abaaa' is 'aaaba'" <| \_ -> Expect.equal "aaaba" (String.reverse "abaaa")]


testModel: Model.Model
testModel = { width = 4, height = 4, livingCells = Set.empty, hoveredCell = ( -1, -1 ), history = [] }

utilityFunctionsSuite : Test.Test
utilityFunctionsSuite =
    Test.describe "Test-Suite to verify the behaviour of utility functions" [
        Test.test "Check that mapCellComponentWithBreak returns input" <| \_ -> Expect.equal 2 (GameOfLife.mapCellComponentWithBreak 2 4)

        , Test.test "Check that mapCellComponentWithBreak returns border" <| \_ -> Expect.equal 3 (GameOfLife.mapCellComponentWithBreak -1 4)

        , Test.test "Check that mapCellComponentWithBreak returns start" <| \_ -> Expect.equal 0 (GameOfLife.mapCellComponentWithBreak 4 4)

        , Test.test "Check that mapCellWithBreak returns input (1,1)" <| \_ -> Expect.equal (1,1) (GameOfLife.mapCellWithBreak (1,1) testModel)

        , Test.test "Check that mapCellWithBreak returns input (0,0)" <| \_ -> Expect.equal (0,0) (GameOfLife.mapCellWithBreak (0,0) testModel)

        , Test.test "Check that mapCellWithBreak breaks for (-1,-1)" <| \_ -> Expect.equal (3,3) (GameOfLife.mapCellWithBreak (-1,-1) testModel)

        , Test.test "Check that mapCellWithBreak breaks for (1,-1)" <| \_ -> Expect.equal (1,3) (GameOfLife.mapCellWithBreak (1,-1) testModel)

        , Test.test "Check that mapCellWithBreak breaks for (-1,1)" <| \_ -> Expect.equal (3,1) (GameOfLife.mapCellWithBreak (-1,1) testModel)

        , Test.test "Check that mapCellWithBreak breaks for (4,4)" <| \_ -> Expect.equal (0,0) (GameOfLife.mapCellWithBreak (4,4) testModel)

        , Test.test "Check that mapCellWithBreak breaks for (1,4)" <| \_ -> Expect.equal (1,0) (GameOfLife.mapCellWithBreak (1,4) testModel)

        , Test.test "Check that mapCellWithBreak breaks for (4,1)" <| \_ -> Expect.equal (0,1) (GameOfLife.mapCellWithBreak (4,1) testModel)

        , Test.test "Check that for illegal input (-1, -1) an empty set is returned." <|
            \_ -> Expect.equal Set.empty (GameOfLife.adjacentCells (-1, -1) testModel)

        , Test.test "Check that for illegal input (1, -1) an empty set is returned." <|
            \_ -> Expect.equal Set.empty (GameOfLife.adjacentCells (1, -1) testModel)

        , Test.test "Check that for illegal input (-1, 1) an empty set is returned." <|
            \_ -> Expect.equal Set.empty (GameOfLife.adjacentCells (-1, 1) testModel)

        , Test.test "Check that for illegal input (1, 4) an empty set is returned." <|
            \_ -> Expect.equal Set.empty (GameOfLife.adjacentCells (1, 4) testModel)

        , Test.test "Check that for illegal input (4, 1) an empty set is returned." <|
            \_ -> Expect.equal Set.empty (GameOfLife.adjacentCells (4, 1) testModel)

        , Test.test "Check that adjacent cells without break are correct" <|
            \_ -> Expect.equal (Set.fromList [(0,0), (0,1), (0,2), (1,0), (1,2), (2,0), (2,1), (2,2)]) (GameOfLife.adjacentCells (1, 1) testModel)

        , Test.test "Check that adjacent cells with line break for input (0,0) are correct" <|
            \_ -> Expect.equal (Set.fromList [(0,1), (0,3), (1,0), (1,1), (1,3), (3,0), (3,1), (3,3)]) (GameOfLife.adjacentCells (0,0) testModel)

        , Test.test "Check that adjacent cells with line break for input (1,0) are correct" <|
            \_ -> Expect.equal (Set.fromList [(0,0), (0,1), (0,3), (1,1), (1,3), (2, 0), (2,1), (2,3)]) (GameOfLife.adjacentCells (1,0) testModel)

        , Test.test "Check that dead cell without living neighbours has zero living neighbours" <|
            \_ -> Expect.equal 0 (GameOfLife.determineCountOfLivingNeighbours (0, 0) testModel)

        , Test.test "Check that living cell without living neighbours has zero living neighbours" <|
            \_ -> Expect.equal 0 (GameOfLife.determineCountOfLivingNeighbours (0, 0) {testModel| livingCells= Set.fromList[(0,0)]})

        , Test.test "Check that dead cell with one living neighbour has one living neighbours" <|
            \_ -> Expect.equal 1 (GameOfLife.determineCountOfLivingNeighbours (1, 0) {testModel| livingCells= Set.fromList[(0,0)]})

        , Test.test "Check that living cell with one living neighbour has one living neighbours" <|
            \_ -> Expect.equal 1 (GameOfLife.determineCountOfLivingNeighbours (1, 0) {testModel| livingCells= Set.fromList[(0,0), (1,0)]})

        , Test.test "Check that living cell with eight living neighbour has eight living neighbours" <|
            \_ -> Expect.equal 8 (GameOfLife.determineCountOfLivingNeighbours (0, 0)
                {testModel| livingCells= Set.fromList[(0,0), (0,1), (0,3), (1, 0), (1,1), (1,3), (3,0), (3,1), (3,3)]})

        , Test.test "Check that in a fully living grid a cell has eight living neighbours" <|
            \_ -> Expect.equal 8 (GameOfLife.determineCountOfLivingNeighbours (1, 1)
                {testModel| livingCells= Set.fromList[(0,0), (0,1), (0,2), (0,3),
                    (1, 0), (1,1), (1,2), (1,3),
                    (2, 0), (2,1), (2,2), (2,3),
                    (3,0), (3,1), (3,2), (3,3)]})

        , Test.test "Check that in a grid with only one dead row the dead cell within that row has six neighbours" <|
            \_ -> Expect.equal 6 (GameOfLife.determineCountOfLivingNeighbours (1, 3)
                {testModel| livingCells= Set.fromList[(0,0), (0,1), (0,2), (0,3),
                    (2, 0), (2,1), (2,2), (2,3),
                    (3,0), (3,1), (3,2), (3,3)]})

        , Test.test "Check that a dead cell next to two living cells stays dead" <| 
            \_ -> Expect.equal False (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(0,0), (0,1)]})



        , Test.test "Check that a dead cell next to three living cells starts living" <| 
            \_ -> Expect.equal True (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(0,0), (0,1), (2,2)]})

        , Test.test "Check that a dead cell next to four living cells stays dead" <| 
            \_ -> Expect.equal False (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(0,0), (0,1), (2,1), (2,2)]})

        , Test.test "Check that a living cell next to dead cells will die" <| 
            \_ -> Expect.equal False (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(1,1)]})

        , Test.test "Check that a living cell next to two living cells will live" <| 
            \_ -> Expect.equal True (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(1,1), (0, 1), (1,2)]})

        , Test.test "Check that a living cell next to three living cells will live" <| 
            \_ -> Expect.equal True (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(1,1), (0,0), (0, 1), (1,2)]})

        , Test.test "Check that a living cell next to four living cells will die" <| 
            \_ -> Expect.equal False (GameOfLife.livesInNextGeneration (1, 1)
                {testModel| livingCells= Set.fromList[(1,1), (0,0), (0, 1), (1,2), (2,2)]})

        , Test.test "Check that all possible positions are created for dimension 3x3" <|
            \_ -> Expect.equal (Set.fromList [(0,0), (0,1), (0,2), (1,0), (1,1), (1,2), (2,0), (2,1), (2,2)])
                (GameOfLife.buildAllPossibleCellsInGrid {testModel| width = 3, height = 3})

        , Test.test "Check that all possible positions are created for dimenstion 3x1" <|
            \_ -> Expect.equal (Set.fromList [(0,0), (1,0), (2,0) ])
                (GameOfLife.buildAllPossibleCellsInGrid {testModel| width = 1, height = 3})

        , Test.test "Check that all possible positions are created for dimenstion 1x3" <|
            \_ -> Expect.equal (Set.fromList [(0,0), (0,1), (0,2) ])
                (GameOfLife.buildAllPossibleCellsInGrid {testModel| width = 3, height = 1})

        , Test.test "Check that next generation is created fine for a single row as Input" <|
            \_ -> Expect.equal (Set.fromList [(0,0), (0,1), (0,2), (0,3), (1,0), (1,1), (1,2), (1,3), (2,0), (2,1), (2,2), (2,3)])
                (GameOfLife.determineNextGeneration {testModel| livingCells = Set.fromList [(1,0), (1,1), (1,2), (1,3)]})
        ]
