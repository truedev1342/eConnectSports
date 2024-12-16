$(document).ready(function() {
    $('#poper').popover({trigger:'hover',
        title: 'Trip Number',
        content: 'This feature is our “Coaches Corner”. By creating a team, you are able to invite players via email to join your roster'+
            'Once players have received their invite, they will be directed to create an account and their trading card.'+
            'Once the card is completed, it will be sent back to a kiosk roster located in a personal administrative page.'+
            'Coaches can edit player stats and track player performance from the administrative page. Note: For easy sign ups, coaches can purchase multiple credits for the entire team.',
        placement:"right",
        delay: { show: 500, hide: 100 }});
    $('#background_pop').popover({trigger:'click',
        title: 'Background',
        content: 'If you wish to have a background image for your card, Click the upload button to be directed to your photo library.'+
            'You can also tile your image by checking the “Tile Background” box.\n'+
            'Note: Background images can be saved from stock image websites or just a simple google image search.',
        placement:"right",
        delay: { show: 700, hide: 100 }});
    $('#appearance_pop').popover({trigger:'click',
        title: 'Appearance',
        content: 'Click the upload button and you will be directed to your photo library. Choose a quality image and it will be uploaded to your card.',
        placement:"right",
        delay: { show: 700, hide: 100 }});
    $('#social_pop').popover({trigger:'click',
        title: 'Appearance',
        content: 'View our list of social networks by clicking the right arrow box. Copy and paste the link from your personal social networks.'+
                 'Note: Multiple social networks can be added to your card by clicking the + icon',
        placement:"right",
        delay: { show: 700, hide: 100 }});
    $('#stat_pop').popover({trigger:'click',
        title: 'Stats',
        content: 'Start by clicking the + icon. Choose from the list provided to add a specific stat for your season.'+
            'Multiple stats can be added and modified at any time. Note: Don’t see a specific stat? Contact us and we’ll get it listed for you.',
        placement:"right",
        delay: { show: 700, hide: 100 }});
    $('#website_pop').popover({trigger:'click',
        title: 'Website',
        content: 'Have a Website, Blog, or YouTube video? Copy and paste the link into the right box, and name your link inside the left box.'+
                 'Note: Multiple links can be created by clicking the + icon.',
        placement:"right",
        delay: { show: 700, hide: 100 }});
    $('#kiosk_pop').popover({trigger:'click',
        title: 'kiosk',
        content: ' The kiosk feature will display your team trading cards. By clicking the “edit” button, you will be able to customize your kiosk with a description, background and team logo.'+
            ' Once completed, your kiosk can be shared via email and social networks by clicking the “Share” drop down box.',
        placement:"right",
        delay: { show: 700, hide: 100 }});

});




