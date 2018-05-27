module ViewTests exposing (..)

import Model exposing (..)
import Util exposing (isRunButtonClickable, isCleanButtonClickable)
import GameOfLifeTests exposing (testModel)
import Expect as Expect
import Test as Test
import Set as Set

isRunButtonClickableTest : Test.Test
isRunButtonClickableTest = 
    Test.describe "Test-Suite to verify the clickability of the run button " [
        Test.test "Check that run button is clickable if a cell is living" <| 
            \_ -> Expect.true "Run Button should be clickable if some cells are living" 
            (isRunButtonClickable {testModel| livingCells= Set.fromList[(0,0)]})
        
        , Test.test "Check That run button is clickable if multiple cells are living" <|
            \_ -> Expect.true "Run Button should be clickable if some cells are living"
            (isRunButtonClickable {testModel| livingCells= Set.fromList[(0,0), (1,1), (2,2)]})
        
        , Test.test "Check that run button is not clickable if no cell is living" <|
            \_ -> Expect.false "Run button should not be clickable if no cell is living" (isRunButtonClickable testModel)
    ]


isCleanButtonClickableTest : Test.Test
isCleanButtonClickableTest = 
    Test.describe "Test-Suite to verify the clickability of the clean button" [
        Test.test "Check that clean button is clickable if a cell is living" <|
            \_ -> Expect.true "Clean Button should be clickable if some cells are living"
            (isCleanButtonClickable {testModel| livingCells= Set.fromList[(0,0)]})
            
        , Test.test "Check that clean button is clickable if multiple cells are living" <|
            \_ -> Expect.true "Clean Button should be clickable if some cells are living"
            (isCleanButtonClickable {testModel| livingCells= Set.fromList[(0,0), (1,1), (2,2)]})

        , Test.test "Check that clean button is clickable if multiple cells are living and history is not empty" <|
            \_ -> Expect.true "Clean Button should be clickable if some cells are living"
            (isCleanButtonClickable {testModel| livingCells= Set.fromList[(0,0), (1,1), (2,2)], history= [Set.fromList[(0,0)]]})

        , Test.test "Check that clean button is clickable if no cells are living and history is not empty" <|
            \_ -> Expect.true "Clean Button should be clickable if some cells are living"
            (isCleanButtonClickable {testModel| history= [Set.fromList[(0,0)]]})

        , Test.test "Check that clean button is not clickable if no cells are living and no history is available" <|
            \_ -> Expect.false "Clean Button should not be clickable if no cells are living and no history is available"
            (isCleanButtonClickable testModel)
    ]