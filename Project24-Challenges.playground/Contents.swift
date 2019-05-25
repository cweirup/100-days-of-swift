import UIKit

var str = "Hello, playground"

// Challenge 1 - Create a String extension that adds a withPrefix() method.
extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        else { return prefix + self }
    }
}

print("pet".withPrefix("car"))
print("prefix".withPrefix("pre"))


// Challenge 2 - Create a String extension that adds an isNumeric property that returns true if the string holds any sort of number.
extension String {
    var isNumeric: Bool {
        if Double(self) == nil { return false }
        else { return true }
    }
}

"42".isNumeric
"65.2".isNumeric
"Hello".isNumeric

// Challenge 3 - Create a String extension that adds a lines property that returns an array of all the lines in a string.
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

let singleLineString = "This is a simple string."
let multiLineString = """
This is a string
It has a couple of lines
I hope you like it
"""
singleLineString.lines
multiLineString.lines
