//  Twitter Feed Info
$(document).ready(function(){
  $('#tweetFeed-blog').jTweetsAnywhere({
	  username: 'idigitallsports',
	  count: 2,
	  showTweetFeed: {
	  showUserScreenNames: true,
	  showActionReply: true,
	  showActionRetweet: true,
	  showActionFavorite: true
	  },
  });
});