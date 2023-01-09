" TEST APPLICATION "
+Object subclass: #Simple
!Simple
preferences
    |wPref bOK label|
    " create preferences window too "
    wPref := Window new; x: 100 y: 100 width: 500 height: 200; center.
    label := Label new;
        x: 50 y: 100 width: 400 height: 30;
        string: 'Preferences pane -- stuff missing'; font: (Font name: 'Times Roman' size: 16).

    bOK := Button new;
         x: 400 y: 30 width: 80 height: 30;
         title: 'OK';
         key: (13 asChar asString);             "13 = ENTER makes this the default button (blue)"
         action: [wPref close]. "close ourselves"

    wPref addPane: label.
    wPref addPane: bOK.
    wPref show.

!

!Simple
initMenu
    |m mi mb m1 m2 m3|
    mb := MacApp menu.

    " 2 ways to create menu:"
    " 1:
    mi := MenuItem title: '' key: '' action: nil.
    mb item: mi.
    m := Menu title: 'Simple'.
    m item: (MenuItem title: 'Simple1' action: ['first item ' printNl]).
    m item: (MenuItem title: 'Simple2' action: ['second one' printNl]).

    mb menu: m forItem: mi.
"
    "2:"

    m1 := List new.
    m1 addLast: (MenuItem title: 'About' action: [
        Alert title: 'Simple V1.0' message: ('Test application', (10 asChar asString), 'Copyright © A Programmer 2023') style: 1.
    ]).
    m1 addLast: (MenuItem separator).
    m1 addLast: (MenuItem title: 'Simple2' action: ['second' printNl ]).
    mb addMenu: 'Simple' items: m1.


!
!Simple
run
    |w wPref ww wh wx wy bOK bCancel label field box p something colour pNow pA pB m m1 m2 sc|

    "mandatory!"
    w := Window new.

    'Created window: ' print. w pointer printNl.

    ww := 1000.
    wx := 100.
    wy := 100.
    wh := 500.

    w x: wx y: wy width: ww height: wh.
    'The initial window dimensions are... ' print. w frame printNl.

    w center.
    w title: 'THIS IS MY NEW WINDOW'.

    'Document directory is ' print. MacApp documentDirectory printNl.
    'Home directory is ' print. MacApp homeDirectory printNl.
    'Executable directory is ' print. MacApp executableDirectory printNl.
    'Resource directory is ' print. MacApp resourceDirectory printNl.

    bOK := Button new;
         x: ((ww / 2) - 80) y: 50 width: 100 height: 30;
         title: 'Prefs';
         key: (13 asChar asString);             "13 = ENTER makes this the default button (blue)"
         action: [self preferences].

    'Created Button OK' printNl.

    bCancel := Button new;
         x: ((ww / 2) + 30) y: 50 width: 100 height: 30;
         title: 'Cancel';
         key: (27 asChar asString);             "27 = ESCAPE would give cancel"
         action: [:sender |
            sender print. ' says: Cancel - closing app...' printNl. MacApp close.
        ].

    'Created Button Cancel' printNl.

    label := Label new;
         x: 50 y: (wh - 100) width: 200 height: 20;
         string: 'Please enter something: ';
         font: (Font name: 'Avenir-Black' size: 14).

    'Created Label' printNl.

    something := ''.
    field := TextField new;
         x: 250 y: (wh - 100) width: (ww - 270) height: 20;
         notification: [:sender :name |
            (name = 'NSControlTextDidChangeNotification') ifTrue: [ something := field string.]
        ].

    " note that you can do  field string: 'xxxx' to set a default"

    'Created TextField' printNl.

    box := TextBox new;
         x: 250 y: 180 width: (ww - 270) height: (wh - 300);
         notification: [
            ":send :name |
            send print. ' says field changed because of a ' print. name print."
            ' It is now... ' print. box string printNl
        ].

    'Created TextBox ' printNl.

    p := Pane new;
        x: 10 y: 10 width: 50 height: 50.

    " colour := Color newRed: 0 green: 0 blue: 255 alpha: 100. "

    p backgroundColor: Color red.
    p borderWidth: 3.
    p borderColor: Color blue.

    " test moving the pane around, with SHIFT"
    pNow := 0@0. pA := 0@0. pB := 0@0.
    p mouseDown: [
       pNow := Pointer location.
       pA := p origin.
    ].
    p mouseDragged: [
       pB := Pointer location.
       p origin: (pB - pNow + pA).
    ] modifier: 1.
    p mouseUp: [ 'thanks for putting me here: ' print. p origin printNl] modifier: 1.

    " does not make sense?"
    p keyDown: 49 action: ['are you pressing me?' printNl]. " space key "

    p rightMouseDown: ['RIGHTTO1' printNl].

    m := Menu title: 'TEST'.
    m1 := (MenuItem title: 'Pick me!' action: [ 'Picked OOOOO' printNl. ]).
    m2 := (MenuItem title: 'No, me!' action: [ 'Or me: AAAAA' printNl. ]).
    m item: m1.
    m item: m2.
    p menu: m.

"
    sc := ScrollPane new ;x: 10 y: 10 width: 200 height: 400.
    sc addPane: p.
"
    " note order: if p is last, all mouse actions will be directed to it, and not to the other panes! "
    w addPane: p.

    w addPane: bOK.
    w addPane: bCancel.
    w addPane: label.
    w addPane: field.
    w addPane: box.

    w onResize: [
        ww := (w frame at: 3).
        wh := (w frame at: 4).
        bCancel x: ((ww / 2) + 30) y: 50 width: 100 height: 30.
        bOK x: ((ww / 2) - 80) y: 50 width: 100 height: 30.
        label x: 50 y: (wh - 100) width: 200 height: 20.
        field x: 250 y: (wh - 100) width: (ww - 270) height: 20.
        box x: 250 y: 180 width: (ww - 270) height: (wh - 300).
    ].

    MacApp onStart: ['I started fine! You can move the red square around, if you like (drag with SHIFT)!' printNl].
    MacApp onClose: ['Stopping now...' printNl. 'The field is... ' print. field string printNl].

    self initMenu.

    MacApp start.      "instead of just 'MacApp run' to pick up onStart: and onClose: blocks"

!

!Simple
files
    |w bOP bSP inFile utFile|

    w := Window new.

    w x: 0 y: 0 width: 600 height: 400; center; title: 'Testing Open/Save files'.

    bOP := Button new;
         x: 210 y: 50 width: 80 height: 30;
         title: 'Open';
         action: [inFile := (MacApp openPanel: '' multi: true dir: false).
            inFile printNl.
         ].

    bSP := Button new;
         x: 310 y: 50 width: 80 height: 30;
         title: 'Save';
         key: (13 asChar asString);             "13 = ENTER makes this the default button (blue)"
         action: [utFile := (MacApp savePanel: 'new.txt'). utFile printNl].

    w addPane: bOP; addPane: bSP.

    MacApp onStart: ['I am OK' printNl].

    MacApp start.

!
