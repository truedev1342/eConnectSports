//  Twitter Feed Info
$(document).ready(function(){
  $('#tweetFeed-footer').jTweetsAnywhere({
	  username: 'iDigitallSports',
	  count: 2,
	  showTweetFeed: {
	     showUserScreenNames: true,
	     showActionReply: true,
	     showActionRetweet: true,
	     showActionFavorite: true
	  }
  });
});