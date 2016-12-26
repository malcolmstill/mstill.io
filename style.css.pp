#lang pollen

body { font-size: 38pt;
       margin: 0; padding: 0;
       -webkit-box-sizing: border-box;
       -moz-box-sizing: border-box;
       -webkit-text-size-adjust: 100%;
       box-sizing: border-box;
       color: #444;
       background-color: white;
       font-family: "Minion Pro", "minion-pro";
       text-rendering: optimizeLegibility;
     }
a { text-decoration: none; }
a:link { color: rgb(223, 85, 3); }
a:visited { color: rgb(223, 85, 3); }
a:hover { color: rgb(223, 85, 3); text-decoration: underline; }
a:active { color: rgb(223, 85, 3); }
.nav2, .nav3, .nav4, .nav5, .nav6, .nav7 { font-size: 100%t; }
.nav3 { padding-left: 2em; }
.nav4 { padding-left: 4em; }
.nav5 { padding-left: 6em; }
.nav6 { padding-left: 8em; }
h1, h2, h3, h4, h5, h6, h7 { font-family: "Myriad Pro", "myriad-pro"; }
p, h1, h2, h3, h4, h5, h6, h7, .footer, .nav2, .nav3, .nav4, .nav5, .nav6, .nav7, blockquote, #disqus_thread, body > a, .category { margin-left: auto; margin-right: auto; width: 90%; }
p { font-size: 100%; }
.highlight { margin-top: 1em; margin-bottom: 1em; max-width: 100%;}
figure .highlight { margin-top: 1em; margin-bottom: 0em; }
p code { font-size: 90%; top: -0.05em; position: relative; background-color: #eee; }
.sourcetable { margin-left: 1em;}

span.righty { position: absolute; right: 1em; font-size: 90%; }

.index-date { font-size: 80%; color: #aaa; margin-bottom: 1em; }
.readmore { display: block; font-size: 100%; margin-top: 0.5em; }
.supref { font-variant-position: super;
          -moz-font-feature-settings: "sups";
          -ms-font-feature-settings: "sups";
          -webkit-font-feature-settings: "sups";
          font-feature-settings: "sups";}
.ord {
    -moz-font-feature-settings: "ordn";
    -ms-font-feature-settings: "ordn";
    -webkit-font-feature-settings: "ordn";
    font-feature-settings: "ordn";
}

#home-wrap {
    font-size: 14pt;
    height: 100%;
    width: 100%;
    overflow: hidden;
    display: -webkit-box;
    display: -moz-box;
    display: -ms-flexbox;
    display: -webkit-flex;
    display: flex;
    -moz-align-items: center;
    -ms-align-items: center;
    -webkit-align-items: center;
    align-items: center;
    -moz-justify-content: center;
    -ms-justify-content: center;
    -webkit-justify-content: center;
    justify-content: center;
    flex-directon: row;
    font-family: "Myriad Pro", "myriad-pro", sans-serif;
}

#home-wrap .home-left {
    padding-right: 1.5em;
    border-right: 1px solid #ccc;
    height: auto;
}

#home-wrap .home-left img {
    border-radius: 100%;
}

#home-wrap .home-right {
    height: auto;
    display: -webkit-box;
    display: -moz-box;
    display: -ms-flexbox;
    display: -webkit-flex;
    display: flex;
    -webkit-flex-directon: row;
    flex-directon: row;
    margin-left: 1.5em;
    padding-top: 1em;
    padding-bottom: 1em;
}

.key { width: 6em; padding-top: 1em; padding-bottom: 1em; }
.key p { font-weight: 600; }
.value { width: 15em; padding-top: 1em; padding-bottom: 1em; }



.category { font-size: 80%; margin-bottom: 2em; }

.abstract > h2 { margin-top: 0em; margin-bottom: 0em; }

.abstract p:nth-child(3) { margin-top: 0.5em; }
/*
.abstract p:nth-child(3) { margin-top: 0.5em; }
*/
hr {
    padding: 0;
    border: none;
    border-top: medium double #000;
    color: #333;
    text-align: center;
    width: 50%;
    margin-top: 1em;
    margin-bottom: 1em;
    border: 0;
    height: 0;
    border-top: 1px solid rgba(0, 0, 0, 0.3);
    border-bottom: 1px solid rgba(255, 255, 255, 0.8);
}
*/

/*
#left { width: 68.2%; height: 100%; background-color: #333; background-image: url("blog/images/malcolm.jpg"); background-size: cover; position: absolute;}
#right { width: 32.8%; height:100; position: absolute; right: 0; }
*/

squo {margin-left: -0.25em;}
dquo {margin-left: -0.50em;}


/*
.key { width: 6em; padding-top: 1em; padding-bottom: 1em; }*/
.key p { font-weight: 600; }
.value { width: 15em; padding-top: 1em; padding-bottom: 1em; }

#wrap img {
    border-radius: 100%;
}


#wrap td { padding-left: 0.75em; }
#wrap table { font-size: 13pt; }
#l {
    border-right: 1px solid #ddd;
    padding-right: 2em;
    padding-left: 0em;
}


.categories {
    margin-top: 0.25em;
    font-style: italic;
}



footer {
    width: 100%;
    height: 5em;
    margin-top: 2em;
}

#toc h2 {
    margin-top: 0em;
}

figure {
    margin-right: auto;
    margin-left: auto;
    margin-top: 1em;
    margin-bottom: 1em;
}

figure.listing {
    width: 100%;
}

figure img {
    width: 100%;
    display: block;
}

figcaption {
    margin-top: 0.5em;
    font-style: italic;
    font-size: 90%;
    width:90%;
    margin-left:auto;
    margin-right:auto;
}

.margin figure {
    position: absolute;
    margin-left: 5%;
    margin-top: 0em;
}

h3 { margin-top: 1em; font-size: 18pt;}
h4 { margin-top: 1em; font-size: 16pt;}

p {

    font-weight: normal;
    margin-bottom: 0em;
    margin-top: 0em;
    line-height: 1.5;
    color: #444;
}

body > p+p, blockquote > p+p { text-indent: 1.5em; }
body > p+p.footnote {
    text-indent: 0em;
}

.flx+p { text-indent: 1.5em; }

p.date {
    text-indent: 0em;
    font-style: italic;
}

h1 {
    font-weight: bold;
    margin-top: 0em;
    margin-bottom: 1em;
    font-size: 120%;
}

p.date+h1 { margin-bottom: 0em;}

h2 {
    font-size: 100%;
}

aside {
    font-style: italic;
    margin: 0;
    padding: 0;
    font-family: "Myriad Pro", "myriad-pro";
    font-size: 10pt;
    text-align: left;
    text-indent: 0em;
    line-height: normal;
    color: #666;
    position: relative;
}

.left, .right {
    font-style: italic;
    margin: 0;
    padding: 0;
    font-family: "Myriad Pro", "myriad-pro";
    font-size: 10pt;
    text-align: left;
    text-indent: 0em;
    line-height: normal;
    color: #666;
    position: relative;
}

aside img {
    width: auto;
    margin-top:0em;
    margin-bottom: 0em;
}

.margin {
      position: relative;
      width: 100%;
}

.margin img {
    width: 100%;
}

.left  {
    position: absolute;
    margin-left: 11%;
    width: 80%;
}

.right {
    position: absolute;
    margin-left: 2em;
    width: 80%;
}

.flx {
    display: flex;
    flex-direction: row;
    width: 100%;
}

.flx aside p { font-size: 11pt; }

.flx aside {
    width:100%;
    line-height: 145%;
    overflow: visible;
    top: +0.2em;
}

.flx aside img, .flx aside p {
    width: 100%;
}

/*
.flx aside:nth-child(3)>p { margin-left: 1em; max-width: 12em; margin-right: 1em; }
*/

.flx >  p:nth-child(2) {
    /*min-width: 45rem;
    max-width: 45rem;
*/
}

svg {
    margin-top: 1em;
    display: block;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 3em;
}

.footer {
    min-height: 100px;
    margin-top: 0em;
        /*border-top: 1px solid #eee;*/
}

/*
pre {
    font-family: "Source Code Pro", "source-code-pro";
    font-size: 12pt;
    color: white;
}
*/

#header {
    width: 100%;
    padding: 1em;
}


.flx aside:nth-child(3)>p { margin-left: 1em; max-width: 12em; margin-right: 1em; }


.flx >  p:nth-child(2) {
    min-width: 90%;
    max-width: 90%;
}

svg {
    margin-top: 1em;
    display: block;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 3em;
}

.footer {
    min-height: 100px;
    margin-top: 0em;
}

pre {
    font-family: "Source Code Pro", "source-code-pro";
    font-size: 190%;
    color: white;
}

#header {
    width: 100%;
    padding: 1em;
    box-sizing: border-box;
}

#header .lefty {
    font-family: "futura-pt", sans-serif;
    font-weight: 700;
}

#header a img {
    width: 3em;
    border-radius: 100%;
}

.strike { text-decoration: line-through; }

blockquote {
    font-style: italic;
    padding-left: 2em;
    padding-right: 2em;
    padding-top: 2em;
    padding-bottom: 2em;
    background-color: #fafafa;
    font-size: 16pt;
    border: 1px solid #eee;
}

.highlight {
    font-family: "Source Code Pro", "source-code-pro";
    color: rgb(3, 85, 223);
    padding-top: 0.75em;
    padding-left: 0em;
    overflow-y: visible;
    overflow-x: auto;
}

.highlight .linenos {
    display: none;
}

@media (min-device-width: 5in)
{
    body
    {
	font-size: 16pt;
    }

    pre {
	font-size: 80%;
    }

    h1
    {
	font-size: 200%;
    }

    p, .abstract h2, h1, .category, .highlight, figure, h2, .nav2
    {
	max-width: 45rem;
    }

    .highlight
    {
	margin-left: auto;
	margin-right: auto;
    }
    
    .abstract h2
    {
	font-size: 120%;
    }

    hr
    {
	margin-top: 2em;
	margin-bottom: 2em;
    }

    figcaption 
    {
	width: 100%;
    }
}
