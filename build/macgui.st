+Application subclass: #MacApp variables: #( ) classVariables: #( pointer mainWindow eventTable actionTable notificationTable documentDirectory homeDirectory executableDirectory resourceDirectory startBlock closeBlock )
+Object subclass: #Point variables: #( x y ) classVariables: #( )
+Object subclass: #Color variables: #( pointer ) classVariables: #( )
+Object subclass: #Pointer variables: #( pointer ) classVariables: #( )
+Object subclass: #Font variables: #( pointer ) classVariables: #( )
+Class subclass: #Menu variables: #( pointer ) classVariables: #( )
+Class subclass: #MenuItem variables: #( pointer ) classVariables: #( )
+Class subclass: #Window variables: #( pointer ) classVariables: #( )
+Window subclass: #Pane variables: #( pointer eventTable ) classVariables: #( )
+Pane subclass: #Control variables: #( pointer ) classVariables: #( )
+Control subclass: #Button variables: #( pointer ) classVariables: #( )
+Control subclass: #TextField variables: #( pointer ) classVariables: #( )
+Control subclass: #TextBox variables: #( pointer ) classVariables: #( )
+TextField subclass: #Label variables: #( pointer ) classVariables: #( )

=MacApp
basicNew
    <250 0 self>                    " initialise the mac app "

!
=MacApp
pointer
	^pointer

!
=MacApp
mainWindow
    (mainWindow isNil) ifTrue: [    " are we initialised? "
        MacApp basicNew.            " do it now "
        eventTable := Dictionary new.
        actionTable := Dictionary new.
        notificationTable := Dictionary new.
    ].
	^mainWindow

!
=MacApp
actionTable
	^actionTable

!
=MacApp
notificationTable
	^notificationTable

!

=MacApp
eventTable
	^eventTable

!
=MacApp
documentDirectory
	^documentDirectory

!
=MacApp
homeDirectory
	^homeDirectory

!
=MacApp
executableDirectory
	^executableDirectory

!
=MacApp
resourceDirectory
	^resourceDirectory

!
=MacApp
startBlock
	^startBlock

!
=MacApp
startBlock: bl
	startBlock := bl

!
=MacApp
closeBlock
	^closeBlock

!
=MacApp
closeBlock: bl
	closeBlock := bl

!
=MacApp
run
	<250 1 self>

!
=MacApp
close
	<250 6 self>

!
=MacApp
onStart: aBlock
    self startBlock: aBlock
!
=MacApp
onClose: aBlock
    self closeBlock: aBlock
!

=MacApp
notification: aBlock

    MacApp basicAction: aBlock table: (self notificationTable) doBasic: false forItem: self.

!

=MacApp
basicAction: aBlock table: aTable doBasic: base forItem: item
    |meth proc s entry args|

    base ifTrue: [item basicAction: aBlock].
    entry := (item pointer asString).

    " 'Creating note for ' print. item class printNl. "

    s := 'note', entry, ': bl s: send n: nam
        bl value: send value: nam.
    '.

    meth := item parseMethod: s.
    meth isNil ifTrue: ['Compile failed!' printNl. ^self].

    args := Array new: 4.
    args at: 1 put: self.
    args at: 2 put: aBlock. " block to exec "
    args at: 3 put: entry.  " sender "
    args at: 4 put: nil.    " this will have the notification name "

    proc := Process new context: (Context new setup: meth withArguments: args).

    aTable at: entry put: proc.

"    'MacApp basicAction for ' print. item class print. '. Basic? ' print. base printNl.
    'In table ' print. aTable printNl.
"

!

=MacApp
start
    MacApp notification: [:sender :nam |
            (nam = 'NSApplicationDidFinishLaunchingNotification' and: [MacApp startBlock notNil]) ifTrue: (MacApp startBlock).
            (nam = 'NSApplicationWillTerminateNotification' and: [MacApp closeBlock notNil]) ifTrue: (MacApp closeBlock).
    ].
    MacApp run.
!

=MacApp
menu
    |m|
    m := Menu new.
    m pointer: (m basicMenubar).
    ^m

!
!Menu
pointer
    ^pointer

!
!Menu
pointer: p
    pointer := p

!
=Menu
title: title
    |m|
    m := super new.
    m pointer: (m basicNew: title).
    ^m

!
!Menu
basicMenubar
    <250 70 self>

!
!Menu
basicNew: t
    <250 71 self t>

!
!Menu
item: m
    |mc pc|
    pc := self pointer.
    mc := m pointer.
    <250 75 self pc mc>

!
!Menu
menu: m forItem: i
    |pc mc ic|
    pc := self pointer.
    mc := m pointer.
    ic := i pointer.
    <250 74 self pc mc ic>

!
=MenuItem
title: t key: k action: aBlock
    |m|
    m := super new.
    m pointer: (m basicMenuItem: t k: k).
    MacApp basicAction: aBlock table: (MacApp actionTable) doBasic: false forItem: m.
    ^m

!

=MenuItem
title: t action: aBlock
    ^(self title: t key: '' action: aBlock).

!

=MenuItem
separator
    |p|
    p := super new.
    p pointer: (p basicSeparator).
    ^p

!
!MenuItem
basicSeparator
    <250 73 self>

!
!MenuItem
basicMenuItem: t k: k
    <250 72 self t k>

!

!MenuItem
pointer
    ^pointer

!
!MenuItem
pointer: p
    pointer := p

!

=Window
new
    |w p|
    w := super new.
    MacApp homeDirectory isNil ifTrue: [ p := MacApp mainWindow] ifFalse: [p := self basicNew].
    w pointer: p.
    ^w

!

=Window
basicNew
    <250 9 self>

!

!Window
show
    |p|
    p := self pointer.
    <250 14 self p>

!

!Window
close
    |p|
    p := self pointer.
    <250 15 self p>

!

!Window
onResize: aBlock

    MacApp basicAction: aBlock table: (MacApp notificationTable) doBasic: false forItem: self.
    <250 7 self self aBlock>        " need to activate this in macos "

!

=Pointer
basic
    <250 50 self>

!
=Pointer
location
    |p|
    p := self basic.
    ^(p at: 1)@(p at: 2)

!
=Pane
new
	|m|
	m := super new.
	m pointer: (m basicNew).
	^m

!

=Color
newRed: r green: g blue: b alpha: a
    |m|
    m := super new.
    m pointer: (m basicNew: r g: g b: b a: a).
    ^m

!
!Color
basicNew: r g: g b: b a: a
    <250 40 self r g b a>

!

" define some standard colours "
=Color
red
    ^(Color newRed: 255 green: 0 blue: 0 alpha: 255)

!
=Color
green
    ^(Color newRed: 0 green: 255 blue: 0 alpha: 255)

!
=Color
blue
    ^(Color newRed: 0 green: 0 blue: 255 alpha: 255)

!
=Color
white
    ^(Color newRed: 255 green: 255 blue: 255 alpha: 255)

!
=Color
black
    ^(Color newRed: 0 green: 0 blue: 0 alpha: 255)

!

!Color
pointer
    ^pointer

!
!Color
pointer: ptr
    pointer := ptr.

!

!Pane
menu: m
    |pc mc|
    pc := self pointer.
    mc := m pointer.
    <250 76 self pc mc>

!
!Pane
focus
    |p|
    p := self pointer.
    <250 16 self p>

!
!Pane
show: y
    |p|
    p := self pointer.
    <250 17 self p y>

!
!Pane
show
    |p|
    p := self pointer.
    <250 17 self p 1>

!
!Pane
hide
    |p|
    p := self pointer.
    <250 17 self p 0>

!

!Pane
action: aBlock

    MacApp basicAction: aBlock table: (MacApp actionTable) doBasic: true forItem: self.

!

!Pane
notification: aBlock

    MacApp basicAction: aBlock table: (MacApp notificationTable) doBasic: true forItem: self.

!

!Pane
basicNew
	<250 12 self>

!
!Button
basicNew
    <250 20 self>

!
!Label
basicNew
    <250 30 self>

!
!TextField
basicNew
    <250 31 self 1>

!
!TextBox
basicNew
    <250 31 self 100>

!

!Window
pointer: ptr
    pointer := ptr.
    ^self

!
!Window
pointer
    ^pointer

!
!Window
title: s
    <250 2 self pointer s>

!
!Window
frame
   <250 8 self pointer>

!
!Window
origin
    |f|
    f := self frame.
    ^(f at: 1)@(f at: 2)

!
!Window
origin: arg
    |f|
    f := self frame.
    self x: (arg x) y: (arg y) width: (f at: 3) height: (f at: 4)

!
!Window
size
    |f|
    f := self frame.
    ^(f at: 3)@(f at: 4)

!
!Window
size: arg
    |f|
    f := self frame.
    self x: (f at: 1) y: (f at: 2) width: (arg x) height: (arg y)

!
!Window
x: xc y: yc width: wc height: hc
    <250 3 self pointer xc yc wc hc>

!
!Window
center
    <250 4 self pointer>

!
!Window
addPane: view
    |p|
    p := view pointer.
    <250 5 self pointer p>

!
!Pane
pointer: ptr
    pointer := ptr.
    ^self

!
!Pane
pointer
    ^pointer

!
!Pane
x: xc y: yc width: wc height: hc
    <250 10 self pointer xc yc wc hc>

!
!Pane
addPane: view
	|p|
	p := self pointer.
	<250 11 self pointer p>

!
!Control
basicAction: bl
    |p|
    p := self pointer.
    <250 23 self p bl>

!
!Control
string: s		" set string "
   |p|
   p := self pointer.
   <250 24 self p s>

!
!Control
string			" get string "
   |p|
   p := self pointer.
   <250 25 self p>

!
!Button
title: s
    |p|
    p := self pointer.
    <250 21 self p s>

!
!Button
key: s
    |p|
    p := self pointer.
    <250 22 self p s>

!
!Button
style: style
    |p|
    p := self pointer.
    <250 26 self p style>

!
!Button
type: type
    |p|
    p := self pointer.
    <250 27 self p type>

!
!Button
state: state
    |p|
    p := self pointer.
    <250 28 self p state>

!
!Button
state
    |p|
    p := self pointer.
    <250 29 self p>

!
!Pane
borderWidth: width
    |p|
    p := self pointer.
    <250 13 self p width>

!
!Pane
backgroundColor: col
    |p c|
    p := self pointer.
    c := col pointer.
    <250 41 self p c>

!
!Pane
borderColor: col
    |p c|
    p := self pointer.
    c := col pointer.
    <250 42 self p c>

!
!TextField
textColor: col
    |p c|
    p := self pointer.
    c := col pointer.
    <250 43 self p c>

!

!Pane
basicMouse: aBlock for: event modifier: mod key: aKey
    |entry eventType meth s args proc|
    " we need to register the event and the method that executes the block
    "

    aKey isNil ifTrue: [entry := ((self pointer asString), '_', (mod asString))]
              ifFalse: [entry := ((self pointer asString), '_', (mod asString), '_', (aKey asString))].

    "event type tables may be missing"
    eventType := (MacApp eventTable at: event ifAbsent: [Dictionary new]).

    s := (event + ': block s: sender n: name
        block value: sender value: name.
    ').

    meth := self parseMethod: s.
    meth isNil ifTrue: ['Compile failed!' printNl. ^self].

    args := Array new: 4.
    args at: 1 put: self.
    args at: 2 put: aBlock. " block to exec "
    args at: 3 put: entry.  " sender "
    args at: 4 put: nil.    " this will have the notification name "

    proc := Process new context: (Context new setup: meth withArguments: args).

    eventType at: entry put: proc.
    MacApp eventTable at: event put: eventType.


!
!Pane
mouseDown: aBlock

    self basicMouse: aBlock for: 'mLDown' modifier: 0 key: nil.

!
!Pane
mouseUp: aBlock

    self basicMouse: aBlock for: 'mLUp' modifier: 0 key: nil.

!
!Pane
mouseDragged: aBlock

    self basicMouse: aBlock for: 'mLDrag' modifier: 0 key: nil.

!
!Pane
rightMouseDown: aBlock

    self basicMouse: aBlock for: 'mRDown' modifier: 0 key: nil.

!
!Pane
rightMouseUp: aBlock

    self basicMouse: aBlock for: 'mRUp' modifier: 0 key: nil.

!
!Pane
rightMouseDragged: aBlock

    self basicMouse: aBlock for: 'mRDrag' modifier: 0 key: nil.

!
!Pane
keyDown: aKey action: aBlock

    self basicMouse: aBlock for: 'kDown' modifier: 0 key: aKey.

!
!Pane
keyUp: aKey action: aBlock

    self basicMouse: aBlock for: 'kUp' modifier: 0 key: aKey.

!
!Pane
mouseDown: aBlock modifier: mod

    self basicMouse: aBlock for: 'mLDown' modifier: mod key: nil.

!
!Pane
mouseUp: aBlock modifier: mod

    self basicMouse: aBlock for: 'mLUp' modifier: mod key: nil.

!
!Pane
mouseDragged: aBlock modifier: mod

    self basicMouse: aBlock for: 'mLDrag' modifier: mod key: nil.

!
!Pane
rightMouseDown: aBlock modifier: mod

    self basicMouse: aBlock for: 'mRDown' modifier: mod key: nil.

!
!Pane
rightMouseUp: aBlock modifier: mod

    self basicMouse: aBlock for: 'mRUp' modifier: mod key: nil.

!
!Pane
rightMouseDragged: aBlock modifier: mod

    self basicMouse: aBlock for: 'mRDrag' modifier: mod key: nil.

!
!Pane
keyDown: aKey action: aBlock modifier: mod

    self basicMouse: aBlock for: 'kDown' modifier: mod key: aKey.

!
!Pane
keyUp: aKey action: aBlock modifier: mod

    self basicMouse: aBlock for: 'kUp' modifier: mod key: aKey.

!

=Font
name: n size: s bold: b italic: i
    |p bc ic|
    p := super new.
    bc := (b ifTrue: [1] ifFalse: [0]).
    ic := (i ifTrue: [1] ifFalse: [0]).
    p pointer: (p basicNew: n s: s b: bc i: ic).
    ^p

!
=Font
name: n size: s
    ^(self name: n size: s bold: false italic: false).

!

!Font
pointer
    ^pointer

!
!Font
pointer: p
    pointer := p

!
!Font
basicNew: n s: s b: b i: i
    <250 60 self n s b i>

!

!Control
font: f
    |p c|
    p := self pointer.
    c := f pointer.
    <250 61 self p c>

!

" various missing methods in standard image "
!SmallInt
/ arg
    ^(self quo: arg)

!

!Integer
/ arg
    ^(self quo: arg)

!

!SmallInt
asString
    ^self printString

!

!Integer
asString
    ^self printString

!

" add missing comma string concatenation "
!String
, arg
   ^(self + arg)

!
!Point
printString
    ^(self x printString) + '@' + (self y printString)

!
!Point
asString
    ^self printString

!
!Point
x
    ^x

!
!Point
x: newx
    x := newx.

!

!Point
y
    ^y

!
!Point
y: newy
    y := newy.

!
!SmallInt
@ arg
    |p|
    p := Point new.
    p x: self.
    p y: arg.
    ^p

!
!Point
+ arg
    (arg class = self class) ifFalse: [self error: 'invalid point addition'].
    x := x + (arg x).
    y := y + (arg y).

!

!Point
- arg
    (arg class = self class) ifFalse: [self error: 'invalid point subtraction'].
    x := x - (arg x).
    y := y - (arg y).

!

"Menu addMethod: 'new' params: '' code: '
    ^(Menu title: (String new)).
'.
"

!Menu
addMenu: title items: items
    |m mi|
    mi := MenuItem title: '' key: '' action: nil.
    self item: mi.
    m := (Menu title: title).
    items do: [:mItem | m item: mItem].
    self menu: m forItem: mi.

!


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
         action: [:sender :name | wPref close]. "close ourselves"

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
    m1 addLast: (MenuItem title: 'About' action: [:sender :name | ('MyApp V1.0', (10 asChar asString), 'Copyright © A Programmer 2023') printNl ]).
    m1 addLast: (MenuItem separator).
    m1 addLast: (MenuItem title: 'Simple2' action: ['second' printNl ]).
    mb addMenu: 'Simple' items: m1.


!
!Simple
run
    |w wPref ww wh wx wy bOK bCancel label field box p something colour pNow pA pB m m1 m2|

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
         notification: [:send :name |
            send print. ' says field changed because of a ' print. name print. ' It is now... ' print. box string printNl
        ].

    'Created TextBox ' printNl.

    p := Pane new;
        x: 10 y: 10 width: 50 height: 50.

    " colour := Color newRed: 0 green: 0 blue: 255 alpha: 100. "

    p backgroundColor: Color red.
    p borderWidth: 3.
    p borderColor: Color blue.

    " test moving the pane around, with SHIFT"
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

    MacApp onStart: ['I started fine! You can move the red square around, if you like!' printNl].
    MacApp onClose: ['Stopping now...' printNl. 'The field is... ' print. field string printNl].


    self initMenu.

    MacApp start.      "instead of just 'MacApp run' to pick up onStart: and onClose: blocks"

!
