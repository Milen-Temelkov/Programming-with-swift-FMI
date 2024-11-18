extension String {
    subscript (_ index: Int) -> String {
        
        get {
             String(self[self.index(startIndex, offsetBy: index)])
        }
        
        set {
            if index >= count {
                insert(Character(newValue), at: self.index(self.startIndex, offsetBy: count))
            } else {
                insert(Character(newValue), at: self.index(self.startIndex, offsetBy: index))
            }
        }
    }
}

func evaluate(expression: String) -> Double {
    if expression[0] != "(" {
        if let value = Double(expression) {
            return value;
        }
    }
    
    var count = 0;
    var leftExpr = "";
    var rightExpr = "";
    var i = 0;
    // (5 + 2) 
    repeat {
         if expression[i] == " " && count == 1{
             break;
         }
         
        if count != 0 {
            leftExpr += expression[i];
        }
        
        if expression[i] == "(" {
            count += 1;
        }
        if expression[i] == ")" {
            count -= 1;
        }
        
        i += 1;
    } while count != 0 && i < expression.count
    
    let op = expression[i + 1];
    
    i += 3;
    
    repeat {
        if expression[i] == ")" && count == 1{
            break;
        }
        if count != 0 {
            rightExpr += expression[i];
        }
        
        if expression[i] == "(" {
            count += 1;
        }
        if expression[i] == ")" {
            count -= 1;
        }
        
        i += 1;
    } while count != 0 && i < expression.count
    
    switch op {
        case "^":
            return pow(evaluate(expression: leftExpr), evaluate(expression: rightExpr));
        case "*":
            return evaluate(expression: leftExpr) * evaluate(expression: rightExpr);
        case "/":
            return evaluate(expression: leftExpr) / evaluate(expression: rightExpr);
        case "+":
            return evaluate(expression: leftExpr) + evaluate(expression: rightExpr);
        case "-":
            return evaluate(expression: leftExpr) - evaluate(expression: rightExpr);
        default:
            return 0.0
    }
    
}