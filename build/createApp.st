+MacApp subclass: #CreateApp
+Application subclass: #MacGUI
+Object subclass: #Program variablesAndSetterGetters: #( name program icon resources image file version sign )

=CreateApp
initialise
    |w ww wh f temp nameLabel nameField program programLabel programName versionLabel versionField btnProgram icon iconName iconImage iconLabel
     btnIcon btnImage resourceLabel btnResource resources resourceList resourceFiles btnOK btnCancel fileLabel fileField
     signLabel signField imageLabel imageName image prg s sure|

    ww := 600. wh := 500.
    w := Window newWindow; title: 'Create Application'; x: 0 y: 0 width: ww height: wh; center.

    prg := Program new.
    icon := Image new.

    nameLabel := Label new;     x: 20 y: (wh - 100) width: 120 height: 20 ; string: 'Application name:'.
    nameField := TextField new; x: 250 y: (wh - 100) width: 330 height: 20.
    programLabel := Label new;  x: 20 y: (wh - 160) width: 100 height: 20 ; string: 'Program name:'.
    btnProgram := Button new;   x: 250 y: (wh - 162) width: 80 height: 30 ; title: 'Select...'.
    programName := Label new;   x: 400 y: (wh - 160) width: 100 height: 20.
    versionLabel := Label new;  x: 460 y: (wh - 160) width: 100 height: 20 ; string: 'Version:'.
    versionField := TextField new; x: 530 y: (wh - 160) width: 50 height: 20; string: '1.0'.
    iconLabel := Label new;     x: 20 y: (wh - 200) width: 100 height: 20; string: 'Icon:'.
    btnIcon := Button new;      x: 250 y: (wh - 202) width: 80 height: 30; title: 'Select...'.
    iconImage := ImagePane new; x: 400 y: (wh - 200) width: 30 height: 30; borderWidth: 1; color: (Color grey).
    signLabel := Label new;     x: 460 y: (wh - 200) width: 100 height: 20; string: 'Sign:'.
    signField := TextField new; x: 530 y: (wh - 200) width: 50 height: 20; string: ''.
    imageLabel := Label new;    x: 20 y: (wh - 240) width: 120 height: 20; string: 'Image file:'.
    btnImage := Button new;     x: 250 y: (wh - 242) width: 80 height: 30; title: 'Select...'.
    imageName := Label new;     x: 400 y: (wh - 240) width: 100 height: 20; string: ''.
    resourceLabel := Label new; x: 20 y: (wh - 280) width: 300 height: 20; string: 'Resources files:'.
    btnResource := Button new;  x: 250 y: (wh - 282) width: 80 height: 30; title: 'Select...'.
    fileLabel := Label new;     x: 460 y: (wh - 280) width: 100 height: 20 ; string: 'File type:'.
    fileField := TextField new; x: 530 y: (wh - 280) width: 50 height: 20; string: ''.
    resourceList := Label new;  x: 20 y: (wh - 420) width: 560 height: 130; string: ''; borderWidth: 1; borderColor: (Color darkGrey).

    btnProgram action: [
        temp := (MacApp openPanel: '' multi: false dir: false).
        programName string: ((temp at: 1) split: '/') last.
        program := (temp at: 1).
    ].
    btnIcon action: [
        temp := (MacApp openPanel: 'icns' multi: false dir: false).
        iconName := (temp at: 1).
        iconName isEmpty ifFalse: [
            f := File openRead: iconName.
            icon := f readContents.
            iconImage image: icon.
            f close.
           " iconImage imageFile: iconName scale: 2."
        ].
    ].
    btnImage action: [
        temp := (MacApp openPanel: '' multi: false dir: false).
        imageName string: ((temp at: 1) split: '/') last.
        image := (temp at: 1).
    ].
    resources := Array new.
    btnResource action: [
        resources := (MacApp openPanel: '' multi: true dir: false).
        s := ''.
        resources do: [:item |
            s := s + item + (10 asChar asString).
        ].
        resourceList string: s.
    ].
    btnOK := Button new; x: (ww/2 - 100) y: 30 width: 80 height: 30; title: 'OK'; setAsDefault.
    btnOK action: [
        sure := (Alert title: 'Create App' message: 'Are you sure you want to create this app?' style: 0 button: 'OK' button: 'Cancel').
        (sure = 1001) ifTrue: [^self].  "//cancel"

        prg name: nameField string.
        prg program: program.
        prg icon: iconName.
        prg image: image.
        prg file: fileField string.
        prg version: versionField string.
        prg sign: signField string.
        prg resources: resources.
        prg create.
        Alert title: 'Create App' message: 'Done.'.
    ].
    btnCancel := Button new; x: (ww/2 + 20) y: 30 width: 80 height: 30; title: 'Cancel'; setAsCancel.
    btnCancel action: [MacApp close].

    w addPane: nameLabel.
    w addPane: nameField.
    w addPane: programLabel.
    w addPane: programName.
    w addPane: btnProgram.
    w addPane: versionLabel.
    w addPane: versionField.
    w addPane: iconLabel.
    w addPane: btnIcon.
    w addPane: iconImage.
    w addPane: signLabel.
    w addPane: signField.
    w addPane: imageLabel.
    w addPane: imageName.
    w addPane: btnImage.
    w addPane: resourceLabel.
    w addPane: fileLabel.
    w addPane: fileField.
    w addPane: btnResource.
    w addPane: resourceList.
    w addPane: btnOK.
    w addPane: btnCancel.

!

=CreateApp
initialiseMenu
    ^self
!

!Program
create
    |n f p e i s v x|
    n := self name.
    p := (((self program) split: '/') last).
    e := self file.
    i := (self icon) isNil ifTrue: [''] ifFalse: [(((self icon) split: '/') last)].
    v := self version.
    x := self sign.

    MacApp createDirectory: n.
    MacApp createDirectory: (n + '/Contents').
    MacApp createDirectory: (n + '/Contents/MacOS').
    MacApp createDirectory: (n + '/Contents/Resources').
    self icon isNil ifFalse: [
        MacApp copyFile: (self icon) to: (n + '/' + i).
    ].

    f := File openWrite: (n + '/Contents/Info.plist').
    s := (self infoList: n program: p icon: i ext: e version: v sign: x).
    f write: s size: (s size).
    f close.
    f := File openWrite: (n + '/Contents/version.plist').
    s := (self versionList: p).
    f write: s size: (s size).
    f close.

    MacApp copyFile: (self program) to: (n + '/Contents/MacOS/' + p).

    MacApp copyFile: self image to: (n + '/Contents/Resources/lst.img').
    self resources do: [:item |
        MacApp copyFile: item to: (n + '/Contents/Resources/' + ((item split: '/') last)).
    ].

    "last, rename <folder> to <folder>.app and we are done! (does this work in real mac app? or only terminal?)"
    MacApp renameFile: n to: (n + '.app').

!

!Program
infoList: n program: p icon: i ext: e version: v sign: x
    |s nl|
    nl := (10 asChar asString).

    s := '<?xml version="1.0" encoding="UTF-8"?>' + nl.
    s := s + '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' + nl.
    s := s + '<plist version="1.0">' + nl.
    s := s + '<dict>' + nl.
	s := s + '<key>CFBundleDevelopmentRegion</key>' + nl.
	s := s + '<string>English</string>' + nl.
	s := s + '<key>CFBundleDisplayName</key>' + nl.
	s := s + '<string>' + n + '</string>' + nl.
	s := s + '<key>CFBundleExecutable</key>' + nl.
	s := s + '<string>' + p + '</string>' + nl.
	s := s + '<key>CFBundleIconFile</key>' + nl.
	s := s + '<string>' + i + '</string>' + nl.
	s := s + '<key>CFBundleIdentifier</key>' + nl.
	s := s + '<string>org.cogex.' + n + '</string>' + nl.
	s := s + '<key>CFBundleInfoDictionary</key>' + nl.
	s := s + '<string>6.0</string>' + nl.
	s := s + '<key>CFBundlePackageType</key>' + nl.
	s := s + '<string>APPL</string>' + nl.
	s := s + '<key>CFBundleSignature</key>' + nl.
	s := s + '<string>' + x + '</string>' + nl.
	s := s + '<key>CFBundleTypeName</key>' + nl.
	s := s + '<string>' + n + ' file</string>' + nl.
	s := s + '<key>CFBundleExtensions</key>' + nl.
	s := s + '<array>' + nl.
    s := s + '<string>' + e + '</string>' + nl.
	s := s + '</array>' + nl.
    s := s + '<key>CFBundleVersion</key>' + nl.
	s := s + '<string>' + v + '</string>' + nl.
    s := s + '</dict>' + nl.
    s := s + '</plist>' + nl.

    ^s

!

!Program
versionList: p
    |s nl|
    nl := (10 asChar asString).
    s := '<?xml version="1.0" encoding="UTF-8"?>' + nl.
    s := s + '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' + nl.
    s := s + '<plist version="1.0">' + nl.
    s := s + '<dict>' + nl.
    s := s + '	<key>ProjectName</key>' + nl.
    s := s + '	<string>' + p + '</string>' + nl.
    s := s + '</dict>' + nl.
    s := s + '</plist>' + nl.

    ^s
!

=CreateApp
initialiseMenu
    |mb m1 m2 m3 m4 tempName mtemp dc cr|
    cr := 13 asChar asString.

    mb := CreateApp menu.
    m1 := List new.
    m1 addLast: (MenuItem title: 'About CreateApp' key: '' action: [
        Alert title: 'About CreateApp' message: ('CreateApp V1.0', cr, cr, 'Copyright © Sam Sandqvist 2023')
    ]).
    m1 addLast: (MenuItem separator).
    m1 addLast: (MenuItem title: 'Settings...' key: ',' action: [CreateApp preferences]).
    m1 addLast: (MenuItem title: 'Quit CreateApp' key: 'q' action: [CreateApp close]).
    mb addMenu: 'CreateApp' items: m1.

    m3 := List new.
    m3 addLast: (MenuItem cutTitle: 'Cut' key: 'x').
    m3 addLast: (MenuItem copyTitle: 'Copy' key: 'c').
    m3 addLast: (MenuItem pasteTitle: 'Paste' key: 'v').
    m3 addLast: (MenuItem selectTitle: 'Select All' key: 'a').

    mb addMenu: 'Edit' items: m3.

    m4 := List new.
    m4 addLast: (MenuItem title: 'CreateApp Help' key: '?' action: [CreateApp help]).
    mb addMenu: 'Help' items: m4.

!
=CreateApp
help
    |helpWin okButton text help cr|
    cr := (13 asChar asString).

    helpWin := Window newWindow; x: 0 y: 0 width: 500 height: 400; title: 'Help'; center.
    text := Label new; x: 10 y: 10 width: 480 height: 340.
    help := 'The CreateApp application allows you to create MacOS applictions.', cr, cr.
    help := help + 'The information needed is the following:', cr.
    help := help + '- Name of application', cr.
    help := help + '- Program, the executable Little Smalltalk runtime (normally lst)', cr, cr.
    help := help + '- Version, default 1.0', cr.
    help := help + '- Icon, a MacOS icon file with extension .icns. Default none', cr.
    help := help + '- Sign, the signature of the developer. 4 characters, or none (default)', cr.
    help := help + '- Image file, the Little Smalltalk image that contains your application', cr.
    help := help + '- File type, the type of files this app should be able to open directly', cr.
    help := help + '- Resources, a list of e.g. image files or other files that should be available for the app', cr, cr.
    help := help + 'Note that an app must have a class MacGUI and a method start that will be executed at startup.', cr, cr.
    help := help + 'The app will be created in the same directory CreateApp is executed from.'.
    text string: help.
    okButton := Button new; x: 10 y: 10 width: 50 height: 30; title: 'OK'; setAsDefault.
    okButton action: [helpWin close].
    helpWin addPane: text.
    helpWin addPane: okButton.
    helpWin show.

!

" This will autostart the app once ready "

!MacGUI
start
    CreateApp new go
!


//MAIN PROGRAM
!CreateApp
go

    CreateApp initialise.

    CreateApp initialiseMenu.

    MacApp onStart: [
        'CreateApp starting...' printNl
    ].
    MacApp onClose: [
        'Closing...' printNl.
    ].

    MacApp start.

!
//autostart after fileIn -- either this or the one above!
"+CreateApp new go
"