str 	[message] {
	This is a sample script from WHOLE.js
	using pipe to open processes.
	
	Thanks for watching :}, 

[doSomething] { return js.pre.first + js.pre.next; } "once :",

module 	[xml] {<${name}>${code}</${name}>},

xml 	[go] {text},

loader 	[pre] { => ${added} ${"\\n"}},

pre	( "This is advanced JavaScript", "The script is run from a virtuial WIN32 environment" ),

filter 	("one", "two", "apple", "three") [numbers] {if (this!="apple") numbers += this + " ";},

{
	console.log(js.pre.toString());
	console.log(js.doSomething());
	console.log(js.filter.numbers() + js.xml.go);
	return js.str.message + ":/" ;
}