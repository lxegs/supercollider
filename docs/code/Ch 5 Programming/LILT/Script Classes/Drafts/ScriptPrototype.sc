/* IZ 2007-01-25 {

ScriptPrototype holds all information that can be shared by Script instances generated from the same script text. This avoids reloading the same script text and generating the basic information for it many times. 

(Given that a session would usually have less than 50 scripts, and that the number of scripts of the same script text would normally be limited to far below this, the following idea for ScriptPrototype looks like overkill. But besides making things a little more efficient it also takes out some of the code from the Script class, thereby reducing it from the overblown situation it is now.)

Drawback - point to take care of: A ScriptPrototype needs updating each time that its script is edited. This can be done automatically if the script is edited either in the ScriptBrowser or when closing a normal SuperCollider Document window opened via the script edit command fom the ScriptBrowser. However, it cannot be automated when editing scripts with an application other than SC client. 

Proposed solution 1: Reload new instance of ScriptPrototype every time that a Script is generated by a command issued by the user via GUI from the ScriptBrowser (Class method: reloadAndMakeScript(folder, name, scriptGroup)). In this way, the overhead is reduced to the reloading part - but the common objects are still shared in memory. For making instances from inside other scripts, as for example when loading sessions, an option for not reloading should be given. Note: if we make this the only method for Sessions, then scripts belonging to the session would need reloading manually if they were edited from another editor. 

Proposed solution 2: Every time that a Script is loaded for which a ScriptPrototype already exists, compare the length of the file with the previously saved length of file (not the text file as this is stripped of RTF) to see if the file has changed. If yes, reload the prototype. This is not a perfect method, but unfortunately there is no way of checking the modification date and time of a file from SC Client yet. 

For now I am going to go for solution 2 above.

} */

ScriptPrototype {
	classvar <all;
	var <folder;	// name of folder where the script is found in ScriptBrowser
	var <name;		// name of script in ScriptBrowser
	var <path;		// path from which the script text is loaded
	var <script;	// script text
	var <envir; 	// used to compile the other data - can be kept as 
					// prototype for restoring other default values
	var <fileLength;	// best currently available check whether the script has changed on disc since
					// this prototype was loaded. Better would be to check modification date and time
					// but this is not available on SC Client yet.
	// following are for gui creation and parameter handling:
	var <>hasBufferInput = false, <>hasAudioInput = false;
	var	<>hasAudioOutput = false, <>hasControlOutput = false;
	var <>controlSpecs, <>defaultGuiBounds, <>labelColor, <>outputColor;

	*initClass {
		all = MultiLevelIdentityDictionary.new;
	}

	*new { | folder, name, path |
		^this.newCopyArgs(folder, name, path).init;
	}
	init {
		/*
		var file;
		file = File(path, "r"
		fileLength = 
		file.close;
		
		*/
	}
	*makeScript { | folder, name, scriptGroup |
	/*
		var prototype;
		prototype = all.atPath(folder, name);
		if (prototype.isNil) {
			
		}
		
	*/

	}
	makeScript { | scriptGroup |

	}
	*reloadAndMakeScript { | folder, name, scriptGroup |
		var path;
		var prototype, script;
		prototype = this.new(folder, name, path);
		^script;
	}
}