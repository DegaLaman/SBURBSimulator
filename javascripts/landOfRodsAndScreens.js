var screens = [];
window.onload = function() {
	makeScreens(256);
	loadImages(38);
}

//css will handle putting them into a grid, don't worry about it.
function makeScreens(number){
		for(var i = 0; i< number; i++){
			var html = "<canvas class = 'screen' id = 'screen" + i + "' width = '45' height = '45'></canvas>";
			$("#landScreens").append(html);
			screens.push(new Screen(document.getElementById("screen"+i)));
		}
}

function loadImages(lastImage){
	var html = "";
	for(var i = 0; i<= numImages; i++){
		html += "<img style = 'display:none;' src = '" + i + ".png'>"
	}
	$("#loading_image_staging").append(html);
}

function makeDistactions(image){
	//get the pixels and store them as data.
}

function Screen(canvas){
	this.canvas = canvas;
	this.state = 0;
}

//raw pixels needed to render this distaction in it's entirety
//if you pass it a screen ID it will return what pixels that screen can render
function Distaction(id, image_data){
	this.id = id;
	this.image_data = image_data
}
