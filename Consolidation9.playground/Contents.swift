import UIKit
import PlaygroundSupport

// Setup Live View
let container = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 250))
container.backgroundColor = .green
PlaygroundPage.current.liveView = container

// Challenge 1 - Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001) })
    }
}

let view = UIView(frame: CGRect(x: 150, y: 25, width: 200, height: 200))
view.layer.cornerRadius = 100
view.backgroundColor = .red
container.addSubview(view)
view.bounceOut(duration: 1.0)

// Challenge 2 - Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.
extension Int {
    func times(_ action: () -> Void) {
        for _ in 0..<abs(self) {
            action()
        }
    }
}

let x = 5
x.times { print("Hello!") }
let y = -3
y.times { print("This was negative!") }
let z = 0
z.times { print("This should never print.") }

// Challenge 3 - Extend Array so that it has a mutating remove(item:) method.
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

var testArray = ["dog", "cat", "fish", "rabbit"]
testArray.remove(item: "dog")
print(testArray)
