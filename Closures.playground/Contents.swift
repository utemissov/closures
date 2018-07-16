import Foundation

class Ball {
    private var onKickCallback: (() -> Void)?
    
    func kick() {
        onKickCallback?()
    }
    
    func onKick(callback: (() -> Void)?) {
        onKickCallback = callback
    }
    
    deinit {
        print("Ball destroyed")
    }
}

/*
 Example one, look at the order of deinits. Player won't be destroyed until ball deinits.
 */
func exampleOne() {
    print("\n\nExample 1: \n------------------------")
    class Player {
        let name: String
        
        init(name: String) {
            self.name = name
        }
        
        deinit {
            print("Player \(name) destroyed")
        }
    }
    
    let ball = Ball()
    if true {
        let john = Player(name: "John")
        
        /*
         Try to uncomment next two lines and comment out the line below them, to see the order of deinits
         */
        ball.onKick {
            print(john.name + " kicked the ball")
        }
    }
    ball.kick()
}

/*
 Example two, look at the order of deinits. This time [weak] reference used
 */
func exampleTwo() {
    print("\n\nExample 2: \n------------------------")
    class Player {
        let name: String
        
        init(name: String) {
            self.name = name
        }
        
        deinit {
            print("Player \(name) destroyed")
        }
    }
    
    let ball = Ball()
    if true {
        let john = Player(name: "John")
        
        /*
         Try to uncomment next two lines and comment out the line below them, to see the order of deinits
         */
        ball.onKick {[weak john] in
            guard let john = john else { return }
            print(john.name + " kicked the ball")
        }
    }
    ball.kick()
}

/*
 Example three -  Leak, now Player owns the object ball
 */
func exampleThree() {
    print("\n\nExample 3: \n------------------------")
    class Player {
        let name: String
        let ball: Ball
        
        init(name: String, ball: Ball) {
            self.name = name
            self.ball = ball
        }
        
        deinit {
            print("Player \(name) destroyed")
        }
    }
    
    let ball = Ball()
    if true {
        let john = Player(name: "John", ball: ball)
        
        ball.onKick {
            print(john.name + " kicked the ball")
        }
    }
    ball.kick()
}

/*
 Example four - fixing the bug from "exampleThree"
 */
func exampleFour() {
    print("\n\nExample 4: \n------------------------")
    class Player {
        let name: String
        let ball: Ball
        
        init(name: String, ball: Ball) {
            self.name = name
            self.ball = ball
        }
        
        deinit {
            print("Player \(name) destroyed")
        }
    }
    
    let ball = Ball()
    if true {
        let john = Player(name: "John", ball: ball)
        //        If you put unowned instead of weak it's going to crash
        ball.onKick { [weak john] in
            guard let john = john else { return }
            print(john.name + " kicked the ball")
        }
    }
    ball.kick()
    
}

exampleOne()
exampleTwo()
exampleThree()
exampleFour()
