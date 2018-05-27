module JavascriptPortsTests exposing (..)

import Main exposing (..)
import Model exposing (..)
import JavascriptPorts exposing (..)
import GameOfLifeTests exposing (testModel)
import Expect as Expect
import Test as Test
import Time as Time
import Set as Set


nextGenerationInMs : Int -> Sub Msg
nextGenerationInMs ms = Time.every ((toFloat ms) * Time.millisecond) nextAutoRunStep


testNextGenerationIsLoadedAutomaticallyInMs : Model -> Test.Test
testNextGenerationIsLoadedAutomaticallyInMs model =
    let expectation = 
        if List.member (nextGenerationInMs model.runSpeedInMs) (subscriptions model) then
            Expect.pass
        else
            Expect.fail ("Expected that a next generation is loaded automatically every "++ (toString model.runSpeedInMs) ++" ms...")
    in
        Test.test ("Expected that a next generation is loaded automatically every "++ (toString model.runSpeedInMs) ++" ms for model " ++ (toString model)) (\_ -> expectation)


testNextGenerationIsNotLoadedAutomatically : Model -> Test.Test
testNextGenerationIsNotLoadedAutomatically model = 
    let expectation =
        if List.member (nextGenerationInMs model.runSpeedInMs) (subscriptions model) then 
            Expect.fail "Expected that a next generation is not loaded automatically"
        else
            Expect.pass
    in
        Test.test ("Expected that a next generation is not loaded automatically for model: " ++ (toString model)) (\_ -> expectation)


autoRunSubscriptionFunctionsSuite : Test.Test
autoRunSubscriptionFunctionsSuite =
    Test.describe "Test-Suite to verify the auto run subscription" [
        testNextGenerationIsNotLoadedAutomatically testModel

        , testNextGenerationIsNotLoadedAutomatically {testModel| autoRunEnabled = True}

        , testNextGenerationIsNotLoadedAutomatically {testModel| livingCells = Set.fromList [(0,0), (1,1)]}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0)]}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0), (1,1)]}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0), (1,1), (2,2)]}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0)], runSpeedInMs = 50}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0), (1,1)], runSpeedInMs = 50}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0), (1,1), (2,2)], runSpeedInMs = 50}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0)], runSpeedInMs = 2000}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0), (1,1)], runSpeedInMs = 2000}

        , testNextGenerationIsLoadedAutomaticallyInMs {testModel| autoRunEnabled = True, livingCells = Set.fromList [(0,0), (1,1), (2,2)], runSpeedInMs = 2000}

    ]