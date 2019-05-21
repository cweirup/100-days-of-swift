var Action = function() {};

Action.prototype = {
    
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title});
},
    
finalize: function(parameters) {
<<<<<<< HEAD
    
=======
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
>>>>>>> 187b3c583e4030da2c42e04c4a0f9d930b529fe4
}
    
};

var ExtensionPreprocessingJS = new Action
