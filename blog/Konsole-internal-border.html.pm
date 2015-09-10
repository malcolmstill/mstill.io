#lang pollen/markup

◊headline{Konsole internal border}
◊define-meta[publish-date]{15/07/2013}
◊define-meta[categories]{linux}
◊define-meta[comments]{true}

Some terminal emulators, such as xterm and urxvt, allow an internal border to be defined, offsetting the terminal text from the edge of the window. I find this to be ◊link["http://en.wikipedia.org/wiki/White_space_%28visual_arts%29"]{very aesthetically pleasing}. As urxvt was giving me issues with copy and paste I thought I'd try using Konsole. Unfortunately Konsole has no equivalent option to ◊code{internalBorder} so I thought all hope was lost.

However, recently I've been playing around with KDE and Qt and I happened upon this nugget of information: Qt applications can be styled with CSS and this can be applied by passing a stylesheet as a command-line option to the application:

◊highlight['bash]{
konsole -stylesheet style.css
}

Then using the following stylesheet I can add a margin to the Konsole window and by setting the background colour to match the background colour Konsole uses for text I achieved the same effect as internalBorder on urxvt.

◊highlight['css]{
QWidget {
    margin: 9;
    background-color: #eeeeee;
}
}

Here's what my urxvt looks like: 
◊figure["images/urxvtborder.png" #:width "45rem"]{Screenshot of urxvt window with internalBorder}

...and here's what Konsole looks like: 
◊figure["images/konsoleborder.png" #:width "45rem"]{Screenshot of konsole window with CSS stylsheet}

Note also that I hide the tab bar and menu bar by default. Hope this helps someone.

