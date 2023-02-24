function tests = TestSignalDetection
  tests = functiontests(localfunctions);
end

function testDPrimeZero(testCase)

  obj      = SignalDetection(15, 5, 15, 5);
  actual   = obj.D_Prime();
  expected = 0;
  verifyEqual(testCase, actual, expected, 'AbsTol', 1e-6);
  
end

function testDPrimeNonzero(testCase)
  
  obj      = SignalDetection(15, 10, 15, 5);
  actual   = obj.D_Prime();
  expected = -0.421142647060282;
  verifyEqual(testCase, actual, expected, 'AbsTol', 1e-6);
  
end

function testCriterionZero(testCase)

  obj = SignalDetection(5, 5, 5, 5);
  actual = obj.Criterion();
  expected = 0;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
  
end

function testCriterionNonzero(testCase)

  obj = SignalDetection(15, 10, 15, 5);
  actual = obj.Criterion();
  expected = -0.463918426665941;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
  
end

%% Object Corruption Test
function testCorruption(testCase)

    obj = SignalDetection(5, 5, 5, 5);
    obj.Hits = 15;
    obj.Misses = 10;
    obj.FalseAlarms = 15;
    obj.CorrectRejections = 5;
    actual = obj.Criterion();
    expected = -0.463918426665941;
    testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);

end

%% + and * Overload Test
function testAddition(testCase)

  obj = SignalDetection(1, 1, 2, 1) + SignalDetection(2, 1, 1, 3);
  actual   = obj.Criterion();
  expected = SignalDetection(3, 2, 3, 4).Criterion;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);

end

function testMultiplication(testCase)

  obj = SignalDetection(1, 2, 3, 1) * 4;
  actual   = obj.Criterion();
  expected = SignalDetection(4, 8, 12, 4).Criterion;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);

end