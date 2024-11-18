func findStart(maze: [[String]]) -> [(Int, Int)] {

    let rows = maze.count;
    let cols = maze[0].count;
    var res: [(Int, Int)] = [];

    for row in 0..<rows {
        for col in 0..<cols {
            if maze[row][col] == "^" {
                res.append((row, col));
            }
        }
    }
    return res;
}

func removeHashtags(maze: [[String]]) -> [[String]] {
    let rows = maze.count;
    let cols = maze[0].count;
    var mazeCopy = maze;
    
    for row in 0..<rows {
        for col in 0..<cols {
            if maze[row][col] == "#" {
                mazeCopy[row][col] = "1";
            }
        }
    }
    
    return mazeCopy;
}

func findPaths(maze: [[String]]) -> Int {
    
    let rightBorder = maze[0].count;
    let downBorder = maze.count;

    var mazeCopy = removeHashtags(maze:maze);
    
    var queue: [(Int, Int)] = findStart(maze:maze);

    if queue.isEmpty {
        return 0;
    }

    var curr:(Int, Int) = (0,0);
    var exitsCount = 0;
    
    while !queue.isEmpty {
        curr = queue.removeFirst();
        
        if mazeCopy[curr.0][curr.1] == "*" {
            mazeCopy[curr.0][curr.1] = "1"
            exitsCount += 1;
            continue;
        }
        mazeCopy[curr.0][curr.1] = "1";
        
        if curr.0 - 1 > -1  {
            if mazeCopy[curr.0 - 1][curr.1] != "1" 
            && !queue.contains(where:{ $0 == (curr.0 - 1, curr.1) }) {
                queue.append((curr.0 - 1, curr.1));
            }
        }
        
        if curr.1 - 1 > -1 {
            if mazeCopy[curr.0][curr.1 - 1] != "1" 
            && !queue.contains(where: { $0 == (curr.0, curr.1 - 1) }) {
                queue.append((curr.0, curr.1 - 1));
            }
        }
        
        if curr.0 + 1 < downBorder {
            if mazeCopy[curr.0 + 1][curr.1] != "1" 
            && !queue.contains(where: { $0 == (curr.0 + 1, curr.1) }) {
                queue.append((curr.0 + 1, curr.1));
            }
            
        }
        
        if curr.1 + 1 < rightBorder {
            if mazeCopy[curr.0][curr.1 + 1] != "1" 
            && !queue.contains(where: { $0 == (curr.0, curr.1 + 1)}) {
                queue.append((curr.0, curr.1 + 1));
            }
            
        }
    }
    
    return exitsCount;
}