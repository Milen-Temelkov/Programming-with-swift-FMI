func countOccurrances(symbol: Character, str: String) -> Int {
    var count = 0
    for char in str {
        if char == symbol {
            count += 1
        }
    }
    return count
}

func prepareSingleOccurancesList (digit: Int) -> [Int] {
    var res1: [Int] = [];
    var res2: [Int] = [];
    
    for i in 0..<10 {
        res1.append(i * 10);
        res2.append(i);
    }

    for i in 0..<res1.count {
        res1[i] += digit;
        res2[i] += digit * 10;
    }
    
    
    
    switch digit {
        case 0:
            return res1;
        default:
            res1.remove(at:(digit));
            res2.remove(at:(digit));
            return res1 + res2; 
    }
    
}

func prepareNoOccurancesList (digit: Int, singleOccur: [Int]) -> [Int] {
    var noOccurances:[Int] = Array(0...99);
    noOccurances = noOccurances.filter { !singleOccur.contains($0) };
    noOccurances.removeAll { $0 == digit * 11 };
    
    return noOccurances;
}

func countEquations(templates: [String], digit: Int, times: Int) -> Int {
    
    let underscore = CharacterSet(charactersIn: "_");
    let charDigit = Character(UnicodeScalar(digit + 48)!);
    var counter = 0;
    
    for equation in templates {
        
        let resStr = String(equation.split(separator:"=")[1]);
        let resInt = Int(resStr);
        let digitOccurancesInResult: Int = countOccurrances(symbol: charDigit, str: resStr);
        
        let operation = equation.split(separator:"=")[0].trimmingCharacters(in: underscore);
        
        counter += countEqHelper(op: operation, res: resInt!, digit: digit, times: (times - digitOccurancesInResult));
    }
    return counter;
}


func countEqHelper(op: String, res: Int, digit: Int, times: Int) -> Int {
    
    if res > 198 || res < -99 {
        return 0;
    }
    
    switch times {
        case 0:
            let oneOccur = prepareSingleOccurancesList(digit: digit);
            let noOccur = prepareNoOccurancesList(digit: digit, singleOccur: oneOccur);
            var counter = 0;
            
            switch op {
                case "+":
                    if res < 0 {
                        return 0;
                    }
                    
                    for i in 0..<noOccur.count {
                        for j in i..<noOccur.count {
                            if noOccur[i] + noOccur[j] == res {
                                counter += noOccur[i] != noOccur[j] ? 2 : 1
                                break;
                            }
                        }
                    }
                    
                    return counter;
                    
                case "-":
                    for i in 0..<noOccur.count {
                        for j in i..<noOccur.count {
                            if abs(noOccur[i] - noOccur[j]) == abs(res) {
                                counter += 1 ;
                                break;
                            }
                            
                            // if noOccur[j] - noOccur[i] == res {
                            //     counter += 1 ;
                            //     continue;
                            // }
                        }
                    }
                    return counter;
                    
                default: 
                    return 0;
            }
            
        case 1: 
            let oneOccur = prepareSingleOccurancesList(digit: digit);
            let noOccur = prepareNoOccurancesList(digit: digit, singleOccur: oneOccur);
            var counter = 0;
            
            switch op {
                case "+":
                    if res < 0 {
                        return 0;
                    }
                    
                    for i in 0..<oneOccur.count {
                        for j in 0..<noOccur.count {
                            if oneOccur[i] + noOccur[j] == res {
                                counter += 2;
                                break;
                            }
                        }
                    }
                    
                    return counter;
                    
                case "-":
                    for i in 0..<oneOccur.count {
                        for j in i..<noOccur.count {
                            if abs(oneOccur[i] - noOccur[j]) == abs(res) {
                                counter += 1 ;
                                break;
                            }
                            
                            // if noOccur[j] - oneOccur[i] == res {
                            //     counter += 1 ;
                            //     continue;
                            // }
                        }
                    }
                    return counter;
                    
                default: 
                    return 0;
            }
              
            
        case 2:
            let oneOccur = prepareSingleOccurancesList(digit: digit);
            let noOccur = prepareNoOccurancesList(digit: digit, singleOccur: oneOccur);
            let twoOccur = digit * 11;
            var counter = 0;
            
            switch op {
                case "+":
                    if res < 0 {
                        return 0;
                    }
                    for i in 0..<oneOccur.count {
                        for j in i..<oneOccur.count {
                            if oneOccur[i] + oneOccur[j] == res {
                                counter += oneOccur[i] != oneOccur[j] ? 2 : 1
                                break;
                            }
                        }
                    }
                    if digit == 0 {
                        return counter;
                    }
                    if noOccur.contains(res - twoOccur) {
                        return counter + 2;
                    }
                    else {
                        return counter;
                    }
                    
                case "-":
            
                    for i in 0..<oneOccur.count {
                        for j in i..<oneOccur.count {
                            if abs(oneOccur[i] - oneOccur[j]) == abs(res) {
                                counter += 1 ;
                                break;
                            }
                            
                            // if oneOccur[j] - oneOccur[i] == res {
                            //     counter += 1 ;
                            //     continue;
                            // }
                        }
                    }
                    
                    if digit != 0 {
                        if noOccur.contains(res + twoOccur) {
                            counter += 1;
                        }
                        if noOccur.contains(-(res - twoOccur)) {
                            counter += 1;
                        }
                    }
                    return counter;
                    
                default: 
                    return 0;
            }
            
        case 3:
            
            let oneOccur = prepareSingleOccurancesList(digit: digit);
            let twoOccur = digit * 11;
            
            switch op {
                case "+":
                    
                    if res < 0 {
                        return 0;
                    }
                    
                    for number in oneOccur {
                        if number + twoOccur == res {
                            return 2;
                        }
                    }
                    
                    return 0;
                    
                case "-":
                    var counter = 0;
                    for number in oneOccur {
                        if abs(number - twoOccur) == abs(res) {
                            counter += 1;
                        }
                    }
                    
                    return counter;
                    
                default: 
                    return 0;
            }
            
            
        case 4:
            if digit == 0 {
                return 0;
            }
            let twoOccur = digit * 11;
            switch op {
                case "+":
                    return twoOccur * 2 == res ? 1 : 0; 
                case "-":
                    return res == 0 ? 1 : 0;
                default: 
                    return 0;
            }
            
            
        default:
            return 0;
            
    } 
    
}