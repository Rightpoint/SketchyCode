var FrameworkPath = FrameworkPath || COScript.currentCOScript().env().scriptURL.path().stringByDeletingLastPathComponent();

(function() {
     var mocha = Mocha.sharedRuntime();
     var frameworkName = "SketchyPlugin";
     var directory = FrameworkPath;

     if (mocha.valueForKey(frameworkName)) {
         return true;
     }
     else if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
         log("✅ loadFramework: `" + frameworkName + "` success!");
         mocha.setValue_forKey_(true, frameworkName);
         return true;
     }
     else {
         log("❌ loadFramework: `" + frameworkName + "` failed!: " + directory + ".");
         return false;
     }
 })();
