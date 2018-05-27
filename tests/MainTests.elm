module MainTests exposing (..)

import Main exposing (..)
import Model exposing (..)
import GameOfLifeTests exposing (testModel)
import Expect as Expect
import Test as Test

checkClippedSizeTest : Test.Test
checkClippedSizeTest = 
    Test.describe "Test-Suite to verify the size clipping" [
        Test.test "Check that new width in window is not clipped" <| 
            \_ -> Expect.equal ({testModel| width = 10}, Cmd.none) (update (ChangeWidth 10) testModel)

        , Test.test "Check that new height in window is not clipped" <| 
            \_ -> Expect.equal ({testModel| height = 10}, Cmd.none) (update (ChangeHeight 10) testModel)

        , Test.test "Check that width above window is clipped to maximum" <| 
            \_ -> Expect.equal ({testModel| width = 20}, Cmd.none) (update (ChangeWidth 21) testModel)

        , Test.test "Check that height above window is clipped to maximum" <| 
            \_ -> Expect.equal ({testModel| height = 20}, Cmd.none) (update (ChangeHeight 21) testModel)

        , Test.test "Check that width below window is clipped to minimum" <| 
            \_ -> Expect.equal ({testModel| width = 4}, Cmd.none) (update (ChangeWidth 3) {testModel| width = 12})

        , Test.test "Check that height below window is clipped to minimum" <| 
            \_ -> Expect.equal ({testModel| height = 4}, Cmd.none) (update (ChangeHeight 3) {testModel| height = 12})
    ]


checkClippedRunSpeedTest : Test.Test
checkClippedRunSpeedTest = 
    Test.describe "Test-Suite to verify the run speed clipping" [
        Test.test "Check that element in window is not clipped" <| 
            \_ -> Expect.equal ({testModel| runSpeedInMs = 100}, Cmd.none) (update (ChangeRunSpeed 100) testModel)

        , Test.test "Check that element above window is clipped to maximum" <| 
            \_ -> Expect.equal ({testModel| runSpeedInMs = 2000}, Cmd.none) (update (ChangeRunSpeed 2001) testModel)

        , Test.test "Check that element below window is clipped to minimum" <| 
            \_ -> Expect.equal ({testModel| runSpeedInMs = 50}, Cmd.none) (update (ChangeRunSpeed 49) testModel)
    ]