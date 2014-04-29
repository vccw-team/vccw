(function(){

    // anchor link
    $('#main-content h2').each(function(i){
    $(this).attr('id', 'h2-'+i);
    $('#navmenu').append('<li><a href="#h2-'+i+'">'+$(this).text()+'</a></li>');
    });

    // smooth scroll
    $('a[href^=#]').click(function(){
    var speed = 500;
    var href= $(this).attr("href");
    var target = $(href == "#" || href == "" ? 'html' : href);
    var position = target.offset().top;
    $("html, body").animate({scrollTop:position}, speed, "swing");
    return false;
    });

})();


function show_contributors(res) {
    var contibutors = res.data;
    var gravatar     = 'http://www.gravatar.com/avatar/';
    var size        = 90;
    $(contibutors).each(function(){
        var avatar = gravatar + this.gravatar_id + '?s=50';
        var li = $('<li />');
        var a  = $('<a />');
        a.attr('href', this.html_url);
        a.attr('title', this.login);
        var img = $('<img />');
        img.attr('src', avatar);
        img.attr('alt', this.login);
        a.append(img);
        li.append(a);
        $('#contributors').append(li);
    })
}

function set_link(res) {
    var tag = res.data[0];
    var link = 'https://github.com/' + gh_user + '/' + gh_project + '/archive/';
    $('#zipball_link').attr('href', link + tag.name + '.zip');
    $('#tarball_link').attr('href', link + tag.name + '.tar.gz');
}

function show_issues(res) {
    var issues = res.data;
    if (issues.length) {
        var ul = $('<ul />');
        $(issues).each(function(){
            var li = $('<li />');
            var a  = $('<a />');
            a.attr('href', this.html_url);
            a.attr('title', this.login);
            a.text(this.title);
            li.append(a);
            ul.append(li);
        });
        $('#issues').append(ul);
    } else {
        var link = 'https://github.com/' + gh_user + '/' + gh_project + '/issues';
        var well = '<div class="well">No issues to show.<br /><a href="' + link + '">Create a new issue.</a></div>';
        $('#issues').append(well);
    }
}

