//  Flickr Feed
$(document).ready(function(){							   
	$.getJSON("http://api.flickr.com/services/feeds/groups_pool.gne?id=998875@N22&lang=en-us&format=json&jsoncallback=?", displayImages);	
	function displayImages(data) {																																   
		var iStart = Math.floor(Math.random()*(11));	
		var iCount = 0;								
		var htmlString = "<ul>";					
		$.each(data.items, function(i,item){				
			if (iCount > iStart && iCount < (iStart + 10)) {
				var sourceSquare = (item.media.m).replace("_m.jpg", "_s.jpg");		
				htmlString += '<li><a href="' + item.link + '" target="_blank">';
				htmlString += '<img src="' + sourceSquare + '" alt="' + item.title + '" title="' + item.title + '"/>';
				htmlString += '</a></li>';
			}
			iCount++;
		});		
	$('#flickr').html(htmlString + "</ul>");
	}	
});