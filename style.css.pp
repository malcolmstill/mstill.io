#lang pollen

◊(define width 45)
◊(define body-font-size 16)

body { font-size: ◊|body-font-size|pt;
       margin: 0; padding: 0;
       box-sizing: border-box;
       color: #444; 
       font-family: "Minion Pro", "minion-pro";
       text-rendering: optimizeLegibility;
     }
a { text-decoration: none; }
a:link { color: rgb(223, 85, 3); }
a:visited { color: rgb(223, 85, 3); }
a:hover { color: rgb(223, 85, 3); text-decoration: underline; }
a:active { color: rgb(223, 85, 3); }
.nav2, .nav3, .nav4, .nav5, .nav6, .nav7 { font-size: ◊|body-font-size|pt; }
.nav3 { padding-left: 2em; }
.nav4 { padding-left: 4em; }
.nav5 { padding-left: 6em; }
.nav6 { padding-left: 8em; }
h1, h2, h3, h4, h5, h6, h7 { font-family: "Myriad Pro", "myriad-pro"; }
p, h1, h2, h3, h4, h5, h6, h7, .footer, .nav2, .nav3, .nav4, .nav5, .nav6, .nav7, blockquote, #disqus_thread, .highlight, body > a, .category { margin-left: auto; margin-right: auto; width: ◊|width|rem; }
.highlight { margin-top: 1em; margin-bottom: 1em; }
figure .highlight { margin-top: 1em; margin-bottom: 0em; }
p code { font-size: 0.8em; top: -0.05em; position: relative; background-color: #eee; }

span.righty { position: absolute; right: 1em; font-size: 14pt; }

.index-date { font-size: 12pt; color: #aaa; margin-bottom: 1em; }
.readmore { display: block; font-size: 14pt; margin-top: 0.5em; }
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

.category { font-size: 12pt; margin-bottom: 2em; }


.abstract > h2 { margin-top: 0em; margin-bottom: 0em; }
.abstract p:nth-child(3) { margin-top: 0.5em; }
hr {
    padding: 0;
    border: none;
    border-top: medium double #333;
    color: #333;
    text-align: center;
    width: 50%;
    margin-top: 2.75em;
    margin-bottom: 3em;

    
    border: 0;
    height: 0;
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    border-bottom: 1px solid rgba(255, 255, 255, 0.3);
}

#left { width: 68.2%; height: 100%; background-color: #333; background-image: url("blog/images/malcolm.jpg"); background-size: cover; position: absolute;}
#right { width: 32.8%; height:100; position: absolute; right: 0; }

squo {margin-left: -0.25em;}
dquo {margin-left: -0.50em;}


#wrap {
    position: absolute;
    display: -webkit-box;
    display: -moz-box;
    display: -ms-flexbox;
    display: -webkit-flex;
    display: flex;
    align-items: center;
    justify-content: center;
    max-width: auto;
    width: auto;
    height: auto;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
    font-family: "Myriad Pro", "myriad-pro", sans-serif;
}

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
    width: auto;
    /*font-size: 14pt;*/
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
    /*width: 85%;*/
    min-width: ◊|width|rem;
    margin-right: auto;
    margin-left: auto;
    margin-top: 1em;
    margin-bottom: 1em;
}

figure.listing {
    width: ◊|width|rem;
}

figure img {
    width: 100%;
    display: block;
}

figcaption {
    margin-top: 0.5em;
    font-style: italic;
}

.margin figure {
    position: absolute;
    margin-left: 5%;
    margin-top: 0em;
}

h2 { margin-top: 2em; font-size: 20pt;}
h3 { margin-top: 1em; font-size: 18pt;}
h4 { margin-top: 1em; font-size: 16pt;}

p {

    font-weight: normal;
    margin-bottom: 0em;
    margin-top: 0em;
    line-height: 1.5;
    /*font-size: ◊|body-font-size|pt;*/
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
/*    margin: 0;*/
/*    width: auto;*/
}

h1 {
    font-weight: bold;
    margin-top: 0em;
    margin-bottom: 1em;
    font-size: 36pt;
    max-width: 80%;
}

p.date+h1 { margin-bottom: 0em;}

h2 {
    font-size: 24pt;
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

.flx aside:nth-child(3)>p { margin-left: 1em; max-width: 12em; margin-right: 1em; }

.flx >  p:nth-child(2) {
    min-width: ◊|width|rem;
    max-width: ◊|width|rem;
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

pre {
    font-family: "Source Code Pro", "source-code-pro";
    font-size: 10pt;
    color: white;
}

#header {
    width: 100%;
    padding: 1em;
}

.flx aside:nth-child(3)>p { margin-left: 1em; max-width: 12em; margin-right: 1em; }

.flx >  p:nth-child(2) {
    min-width: ◊|width|rem;
    max-width: ◊|width|rem;
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

pre {
    font-family: "Source Code Pro", "source-code-pro";
    font-size: 10pt;
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
    font-size: ◊|body-font-size|pt;
    border: 1px solid #eee;
}

.highlight {
    font-family: "Source Code Pro", "source-code-pro";
    font-size: 10pt;
    color: rgb(3, 85, 223);
    padding-top: 1em;
    padding-left: 1em;
    overflow-y: visible;
    overflow-x: auto;
}

.highlight .linenos {
    display: none;
}

@media (max-width: 960px) {
    .margin figure {
	position: relative;
    }
    
    .flx {
	flex-direction: column;
	width: 100%;
	margin-left: auto;
	margin-right: auto;
    }

    .flx > p {
    	max-width: ◊|width|rem;
	margin-left: auto;
	margin-right: auto;
    }   	   

    .left, .right { position: relative; margin: 0; margin-left: auto; margin-right: auto; }

    aside div {
    	  position: initial;
	  display: hidden;
    }
}

@media (max-width: 800px) {
   
    p, h1, h2, h3, h4, h5, h6, h7, .nav2, .nav3, .nav4, .nav5, .nav6, .nav7, blockquote, .footer, #disqus_thread { min-width: auto; max-width: auto; width: auto; margin-left: 2rem; margin-right: 2rem;  }
    figure, .highlight { min-width: 100%; max-width: 100%; margin-left: 0; margin-right: 0; }
    .flx p:nth-child(1), .flx p:nth-child(2), .flx p:nth-child(3) { margin-left: 2rem; margin-right: 2rem; min-width: initial; }
    .flx { flex-direction: column; max-width: ◊|width|rem; padding: 0; margin-right: auto; margin-left: auto; }
    .flx aside { display: none; width: 0; padding: 0; margin: 0; }
    
    #header {
        width: auto;
    }

    pre.src {
        width: auto;
    }
}

@media only screen and (max-device-width: 480px) {
    body { font-size: 28pt; }
    p { width: 100%; margin-left: 1em; margin-right: 1em; }
}

