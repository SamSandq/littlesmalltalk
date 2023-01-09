// Little Smalltalk
//
// GUI support
//
// Part of Little Smalltalk MacGUI implementation
// copyright (c) Sam Sandqvist 2023
//
// see LICENCE file for details
//
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "memory.h"
#import "globals.h"

#import "mac_gui.h"

id myMainWindow = NULL;
id myDelegate = NULL;

@interface MyAppDelegate : NSWindow <NSTextFieldDelegate, NSWindowDelegate, NSMenuDelegate, NSDraggingSource,
                                     NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDelegate, NSDraggingDestination> {
    NSWindow *window;
}

@end

// @interface SpecialDelegate: NSObject <NSApplicationDelegate, NSDraggingDestination> {}
// @end

//-----------------------------------------------------------------------------
//check if action has been specified for the event and execute the block if so
//THIS IS THE COMMON CODE FOR ALL MOUSE&KEY EVENTS
BOOL eventCommon(void *sender, NSEvent *theEvent) {

    //form event string and sender
    char stringEvent[10] = "";

    //something happened... get right table to check if we can respond
    NSEventType type = [theEvent type];
    int modifier = [theEvent modifierFlags] >> 17;

    switch (type) {
        case NSEventTypeLeftMouseDown:
            strcpy(stringEvent, "mLDown");
            break;
        case NSEventTypeRightMouseDown:
            strcpy(stringEvent, "mRDown");
            break;
        case NSEventTypeLeftMouseDragged:
            strcpy(stringEvent, "mLDrag");
            break;
        case NSEventTypeLeftMouseUp:
            strcpy(stringEvent, "mLUp");
            break;
        case NSEventTypeRightMouseUp:
            strcpy(stringEvent, "mRUp");
            break;
        case NSEventTypeRightMouseDragged:
            strcpy(stringEvent, "mRDrag");
            break;
        case NSEventTypeKeyDown:
            strcpy(stringEvent, "kDown");
            break;
        case NSEventTypeKeyUp:
            strcpy(stringEvent, "kUp");
            break;
        default:
            return FALSE;
            break;
    }

    //get at the process, if any
    struct object *eventTable = getClassVariable("MacApp", "eventTable");     //always there
    struct object *eventType = dictLookup(eventTable, stringEvent);
    if (!NOT_NIL(eventType)) return FALSE;

    //ok, so we have events registered... but for us?
    //form pointer based on sender for lookup of process
    char ptr[40] = "";
    if (type == NSEventTypeKeyDown || type == NSEventTypeKeyUp) {
        //get key and form pointer with it as well
        int keyCode = [theEvent keyCode];
        sprintf(ptr, "%lld_%d_%d", (long long) sender, keyCode, modifier);
    } else {
        sprintf(ptr, "%lld_%d", (long long) sender, modifier);
    }

    struct object *myProcess = dictLookup(eventType, ptr);
    if (!NOT_NIL(myProcess)) return FALSE;

    //YES! do it.

    /* protect the Process from GC */
    rootStack[rootTop++] = myProcess;

    if (myProcess != rootStack[rootTop-1]) {
       myProcess = rootStack[rootTop-1];
       /* load anything else you need from the Process */
    }

    //... build Context ...
    struct object *myContext = myProcess->data[contextInProcess];
    rootStack[rootTop++] = myContext;

    //execute the Process
    int ret = execute(myProcess, 0);

    //restore stuff
    struct object *context = rootStack[--rootTop];
    struct object *process = rootStack[--rootTop];

    process->data[contextInProcess] = context;
    context->data[bytePointerInContext] = newInteger(0);
    context->data[stackTopInContext] = newInteger(0);

    return TRUE;
}

//-----------------------------------------------------------------------------
//check if action has been specified for the drag/drop and execute the block if so
//THIS IS THE CODE FOR ALL DRAGS&DROPS
//types: 0 enter, 1 prepare, 2 perform, 3 end, 4 exit (from target), 5 conclude
BOOL dragCommon(void *view, id <NSDraggingInfo> info, int type) {

//NSDraggingInfo:
//     draggingSequenceNumber=0x88000000
//     draggingDestinationWindow=<MyAppDelegate: 0x7fe40880e3c0>
//     draggingSourceOperationMask=0x1
//     draggingLocation={89.5670166015625, 1006.8539276123047}
//     draggingPasteboard=<NSPasteboard: 0x6000031511a0>

//     Tree *table = event[type];      //normals are here, incl NSApplicationDefined
//
//     //form pointer into action table
//     char *ptr = GC_MALLOC(40);
//
//     //lookup block
//     Object *actionBlock = NULL;
//
//     sprintf(ptr, "%p", view);
//     actionBlock = lookup2(ptr, table);
//
//     if (actionBlock == NULL) {return FALSE; };                      //no action specified, system handles
//
//     //now, we want the stack to have the following info
//     //what (the item we are dragging)
//     //type (the type of the item, as registered
//     //sender (where, i.e., who is telling us that something is dropping on them)
//
//     Object *send = lookup2(ptr, senderTable);
//     NSPasteboard *p = [info draggingPasteboard];
//
// //     NSArray *supportedTypes = [(NSView *) view registeredDraggedTypes];
// //     NSString *bestType = [p availableTypeFromArray: supportedTypes];
// //     NSLog(@"Best: %@ out of %@", bestType, supportedTypes);
//
//     //multiple file items?
//     NSArray *plist = [p propertyListForType: NSFilenamesPboardType];
//
//     if ([plist count] > 0) {
//         //handle the items one by one
//         for (NSString *f in plist) {
//             //create call and do it
//             PUSH(send);                                     //who sent it
//             PUSH(newString("NSFilenamesPboardType"));       //type of item
//             PUSH(newString([f UTF8String]));             //item itself
//             doBlockValue4(actionBlock);     //three arguments
//         }
//         return YES;
//     }
//
//     Object *itemObject = nilObject;
//     Object *itemType = NULL;
//     NSString *internal = [p stringForType: @"funtus.internal"];
//     NSString *item = nil;
//     if (internal != nil) {
// //        NSLog(@"Got internal object!");
//         char *s = [internal UTF8String];
// //        printf("The char ptr is: %p\n", s);
//         sscanf(s, "%p", &itemObject);
// //        printf("...and pointer is: %p\n", itemObject); dumpObject(itemObject);
//         itemType = newString("funtus.internal");
//     } else {
//         //assume tag string
//         item = [p stringForType: NSStringPboardType];
//         if (item != nil) {
//             itemObject = newString([item UTF8String]);
//             itemType = newString("NSStringPboardType");
//         } else {
//         //check collection
//             item = [p stringForType: @"funtus.collection"];
//             if (item != nil) {
//                 itemObject = newString([item UTF8String]);
//                 itemType = newString("funtus.collection");
//             } else return NO;       //no other possibilities
//         }
//     }
//
//     //create call and do it
//     PUSH(send);
//     PUSH(itemType);
//     PUSH(itemObject);
//     doBlockValue4(actionBlock);     //three arguments

    return YES;
}




//OWN CLASSES
//own MyView
@interface MyView : NSView {
    BOOL acceptResponder;
    BOOL isFlipped;
}

@property BOOL acceptResponder, isFlipped;
- (BOOL) acceptResponder;
- (BOOL) isFlipped;
@end

@implementation MyView

@synthesize acceptResponder;
@synthesize isFlipped;

//init
- (id) init {
    self = [super init];
    acceptResponder = NO;           //default is not
    isFlipped = NO;                 //normally no
    return self;
}

// -----------------------------------
// First Responder Methods
// - (BOOL) acceptsFirstResponder {
//     return acceptResponder;         //when asked... NOTE: may be set with [myView setAcceptResponder: YES]; !!
// }
//
// - (BOOL) isFlipped {
//     return isFlipped;               //may be set with [myView setIsFlipped];
// }

//catch the events
- (void) mouseDown: (NSEvent *) theEvent {
    if ([theEvent clickCount] == 2) {
        NSEvent *doubleClick = [NSEvent otherEventWithType: NSEventTypeApplicationDefined
                            location: NSZeroPoint modifierFlags: 0 timestamp: 0 windowNumber: 0 context: 0 subtype: 0 data1: 0 data2: 0];
        if (!eventCommon(self, doubleClick)) [super mouseDown: theEvent];
    } else
    if (!eventCommon(self, theEvent)) [super mouseDown: theEvent];
}

- (void) mouseDragged: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super mouseDragged: theEvent];
}

- (void) mouseUp: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super mouseUp: theEvent];
}

- (void) mouseMoved: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super mouseMoved: theEvent];
}

- (void) rightMouseDown: (NSEvent *) theEvent {
    if (self.menu) {
        NSPoint pt = [self convertPoint: [theEvent locationInWindow] fromView: nil];
        [self.menu popUpMenuPositioningItem: nil atLocation: pt inView: self ];
    }
    //same effect with the call to super...
//    [super rightMouseDown: theEvent];
    eventCommon(self, theEvent);
//    if (!eventCommon(self, theEvent)) [super rightMouseDown: theEvent];
}

- (void) rightMouseDragged: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super rightMouseDragged: theEvent];
}

- (void) rightMouseUp: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super rightMouseUp: theEvent];
}

- (void) keyDown: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super keyDown: theEvent];
}

- (void) keyUp: (NSEvent *) theEvent {
    if (!eventCommon(self, theEvent)) [super keyUp: theEvent];
}

- (void) willOpenMenu: (NSMenu *) menu withEvent: (NSEvent *) theEvent {
//    printf("MyView will open menu %p!\n", menu);
}

- (void) needsUpdateMenu: (NSMenu *) menu withEvent: (NSEvent *) theEvent {
//    printf("MyView will update menu %p!\n", menu);
}

- (void) didCloseMenu: (NSMenu *) menu withEvent: (NSEvent *) theEvent {
//    printf("MyView did close menu %p!\n", menu);
}

//drag & drop
- (NSDragOperation) draggingEntered: (id <NSDraggingInfo>) sender {
    dragCommon(self, sender, 0);
//    NSLog(@"Enter");
    //prevent operations on source NSStringFromClass(self.class)
    id src = NSStringFromClass([[sender draggingSource] class]);
//    id slf = NSStringFromClass([self class]);

    if ([src isEqualToString: @"MyImageView"]) {
//        NSLog(@"None");
        return NSDragOperationNone;
    }
    return NSDragOperationGeneric;
};

- (BOOL) prepareForDragOperation: (id <NSDraggingInfo>) sender {
//    NSLog(@"Prepare");
    dragCommon(self, sender, 1);
    return YES;
};

- (BOOL) performDragOperation: (id <NSDraggingInfo>) sender {
//    NSLog(@"Perform");
    //if ([super performDragOperation: sender])
    dragCommon(self, sender, 2);
    return YES;
};

- (void) draggingEnded: (id <NSDraggingInfo>) sender {
//    NSLog(@"End");
    dragCommon(self, sender, 3);
};

- (void) draggingExited: (id <NSDraggingInfo>) sender {
//    NSLog(@"Exit");
    dragCommon(self, sender, 4);
};

- (void) concludeDragOperation: (id <NSDraggingInfo>) sender {
//    NSLog(@"Conclude");
    dragCommon(self, sender, 5);
};

@end        //MyView end

//ALERTPANEL, OPENPANEL, SAVEPANEL
//-----------------------------------------------------------------------------
//AlertPanel:  result := Alert title: 'Application' message: 'Are you sure?'. result= 1000 OK, 1001 cancel.
// res := Alert title: tit message: msg style: x button: 'OK' button: 'Cancel'. Leave the last button blank if you don't want it.
//styles: Warning: 0, Info: 1, Critical: 2

int doAlertPanel(char *title, char *message, int style, char *button1, char *button2) {

    NSAlert* alert = [[NSAlert new] autorelease];
    [alert setMessageText: [NSString stringWithUTF8String: title]];
    [alert setInformativeText: [NSString stringWithUTF8String: message]];
    [alert setAlertStyle: style];
    if (strlen(button1) > 0) [alert addButtonWithTitle: [NSString stringWithUTF8String: button1]];
    if (strlen(button2) > 0) [alert addButtonWithTitle: [NSString stringWithUTF8String: button2]];

    NSModalResponse response = [alert runModal];

    return response;
}

//-----------------------------------------------------------------------------
//savePanel: result := Application savePanel: 'default.txt'.
//on cancel returns the empty, otherwise file name.
char *doSavePanel(char *title) {

    NSSavePanel* saveFileDialog = [[[NSSavePanel alloc] init] autorelease];

//   [saveFileDialog setCanCreateDirectories:YES];
//   [saveFileDialog setAllowedFileTypes:[NSArray arrayWithObjects:@"txt", @"md", nil]];
//   [saveFileDialog setDirectoryURL:[NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) firstObject]]];
    [saveFileDialog setNameFieldStringValue: [NSString stringWithUTF8String: title]];

//    NSLog(@"Save with: %s", title);

    NSModalResponse response = [saveFileDialog runModal];
    if (response == NSModalResponseOK) return (char *) [[[saveFileDialog URL] path] UTF8String];

    return NULL;
}

//-----------------------------------------------------------------------------
//OpenPanel:  Application openPanel type: 'txt' multi: 0/1 dir: 0/1. If type is empty all files are accepted
//returns Array with results. Empty if cancelled
Object *doOpenPanel(char *type, int multi, int dir) {

    NSURL *dirURL = nil;
    Object *arr = newArray(0);      //default is empty Array (=nothing selected)
    int arrSize = 0;

    int canDir = 0;
    int mulFil = 0;
    int canFil = 1;

    if (multi > 0) {
        mulFil = 1;
    }

    if (dir > 0) {
        canDir = 1;
        canFil = 0;
    }

    NSOpenPanel* openFileDialog = [[[NSOpenPanel alloc] init] autorelease];
    [openFileDialog setCanChooseFiles: canFil];
    [openFileDialog setCanChooseDirectories: canDir];
    [openFileDialog setAllowsMultipleSelection: mulFil];
    if (strlen(type) > 0) {
        [openFileDialog setAllowedFileTypes: [NSArray arrayWithObjects: [NSString stringWithUTF8String: type], nil]];
    };

//  [openFileDialog setDirectoryURL:[NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) firstObject]]];

    NSModalResponse response = [openFileDialog runModal];

    if (response == NSModalResponseOK) {
        dirURL = [[openFileDialog URLs] objectAtIndex: 0];
        if (mulFil && !canDir) {

            arrSize = [[openFileDialog URLs] count];
            arr = newArray(arrSize);
            int i = 0;
            for ( NSURL * thisURL in [openFileDialog URLs] ) {
                arr->data[i++] = newString( (char *) [[thisURL path] UTF8String]);
            }

        } else if (mulFil && canDir) {    //directory
            NSArray *dirContents = [[NSFileManager defaultManager]  contentsOfDirectoryAtPath:
                [[[openFileDialog URLs] objectAtIndex: 0] path] error: nil];

            arrSize = [dirContents count];
            arr = newArray(arrSize);
            int i = 0;
            for ( NSString * thisPath in dirContents ) {
                NSString *fullPath = [[ (NSString *) [dirURL path] stringByAppendingString: @"/" ] stringByAppendingString: thisPath];
                arr->data[i++] = newString( (char *) [fullPath UTF8String]);
            }

        } else if (canDir && !mulFil){ //just dir
            arr = newArray(1);
            arr->data[0] = newString((char *) [ (NSString *) [dirURL path] UTF8String]);
        } else {    //single file
            arr = newArray(1);
            arr->data[0] = newString((char *) [[(NSURL*)[[openFileDialog URLs] objectAtIndex: 0] path] UTF8String]);
        }
    }

    return arr;
}

//SCROLLVIEW
//-----------------------------------------------------------------------------
//create scroll view
long long doCreateScrollView() {

    NSScrollView *view = [[[NSScrollView alloc] initWithFrame: CGRectZero] autorelease];
    // the scroll view should have both horizontal and vertical scrollers (settable?)
    [view setHasVerticalScroller: YES];
    [view setHasHorizontalScroller: YES];
    [view setLineScroll: 1];

    return (long long) view;
}

//-----------------------------------------------------------------------------
//add view  to scrollview
void doAddViewToScrollView(void *scrollPane, void *view) {
    [(NSScrollView *) scrollPane setDocumentView: (NSView *) view];
}


//MENUS
//-----------------------------------------------------------------------------
//create and return empty menubar. Use: mb := MacApp menu.
long long doGetMenubar() {

    id menubar = [[NSMenu new] autorelease];        //create a menu...
    [NSApp setMainMenu: menubar];                   //...and make it main.

    //NSLog(@"Menubar %lld created", menubar);

    return (long long) menubar;
}

//-----------------------------------------------------------------------------
//create and return empty menu. Use m1 := Menu new: title
long long doCreateMenu(char *title) {

    id menu = [[NSMenu new] autorelease];        //create a menu...
    [menu setTitle: [NSString stringWithUTF8String: title]];
    [menu setAutoenablesItems: NO];

    //NSLog(@"Menu %lld created", menu);

    return (long long) menu;
}

//-----------------------------------------------------------------------------
//create new menu item (not yet connected to anything)
long long doCreateMenuItem(char *key, char *title) {

    NSString *t = [NSString stringWithUTF8String: title];
    NSString *k = [NSString stringWithUTF8String: key];

    id menuItem = [[[NSMenuItem alloc]
        initWithTitle: t
        action: @selector(action:)              //NB: this set in the actionTable
        keyEquivalent: k] autorelease];

    //NSLog(@"MenuItem %lld created", menuItem);

    return (long long) menuItem;
}

//-----------------------------------------------------------------------------
//create separator item
long long doCreateMenuItemSeparator() {
    return (long long) [NSMenuItem separatorItem];
}

//-----------------------------------------------------------------------------
//add menu item as submenu to another menu (connect it)
void doSetMenuAsSubmenuForItem(void *menu, void *sub, void *item) {
    //NSLog(@"set menu %lld to be submenu for item %lld in menu %lld", sub, item, menu);
    [(id) menu setSubmenu: (id) sub forItem: (id) item];
}

//-----------------------------------------------------------------------------
//add item to menu
void doAddMenuItem(void *menu, void *item) {
    NSInteger howMany = [(NSMenu *) menu numberOfItems];
    [(NSMenuItem *) item setTag: howMany];           //not used (yet?)
    [(NSMenu *) menu addItem: (NSMenuItem *) item];
    //NSLog(@"add item %lld to menu %lld", item, menu);
}

//-----------------------------------------------------------------------------
//add menu as popup menu to a view (connect it)
void doAddMenuToView(void *w, void *m) {
    [(NSView *) w setMenu: (NSMenu *) m];
    //NSLog(@"set menu %lld to view %lld", m, w);
}

//-----------------------------------------------------------------------------
//create font
// use: fnt := Font name: 'Arial' size: 16 bold: false italic: false.
//
long long doCreateFont(char *name, int fSize, int fBold, int fItal) {

    NSString *fName = [NSString stringWithUTF8String: name];

    NSFont *font = [[NSFontManager sharedFontManager] convertFont: [[NSFontManager sharedFontManager] convertFont: [NSFont fontWithName: fName size: fSize]]];
    if (fBold) [[NSFontManager sharedFontManager] convertFont: font toHaveTrait: NSFontBoldTrait];
    if (fItal) [[NSFontManager sharedFontManager] convertFont: font toHaveTrait: NSFontItalicTrait];

    return (long long) font;
}

//-----------------------------------------------------------------------------
//set text font for stuff
void doSetFont(void *w, void *font) {
    [(NSControl *) w setFont: (NSFont *) font];
}

//-----------------------------------------------------------------------------
//set focus to view in window
void doSetFocus(void *w) {
    [myMainWindow makeFirstResponder: (NSView *) w];
}

//-----------------------------------------------------------------------------
//show or hide view in window
void doSetShowView(void *w, int hide) {
    if (hide == 0) {
        [(NSView *) w setHidden: YES];
    } else {
        [(NSView *) w setHidden: NO];
    }
}

//-----------------------------------------------------------------------------
//is hidden or shown?
struct object *doGetHiddenStatus(void *w) {
    if ([(NSView *) w isHidden]) return trueObject;
    else return falseObject;
}

//-----------------------------------------------------------------------------
//remove view
void doRemoveView(void *w) {
    [(NSView *) w removeFromSuperview];
}

//-----------------------------------------------------------------------------
//create window
long long doCreateWindow() {

    //Pick your window style:
    NSUInteger windowStyle = NSWindowStyleMaskTitled | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable;

    //NSRect r = NSMakeRect(100, 100, 100, 100);
    NSRect r = NSZeroRect;
    NSWindow *win = [[NSWindow alloc] initWithContentRect: r styleMask: windowStyle backing: NSBackingStoreBuffered defer: NO];

    [win setOpaque: YES];
    [win setHasShadow: YES];
    [win setHidesOnDeactivate: NO];

//    [win setBackgroundColor: [NSColor whiteColor]];          //separate call
//    [win setIsVisible: YES];                                 //separate call

    return (long long) win;
}

//-----------------------------------------------------------------------------
//show window
void doShowWindow(void *w) {

    [(NSWindow *) w setFrame: [(NSWindow *) w frame] display: YES];
    NSWindowController *windowController = [[NSWindowController alloc] initWithWindow: (NSWindow *) w];
    [windowController showWindow: nil];
}

//-----------------------------------------------------------------------------
//close window
void doCloseWindow(void *w) {
    [(NSWindow *) w close];
    [(NSWindow *) w release];
}

//-----------------------------------------------------------------------------
//Get mouse position in window, return as Array x,y
struct object *doGetMousePositionInWindow() {

	NSPoint mousePos = [myMainWindow mouseLocationOutsideOfEventStream];

    //create two-array
    struct object *arr = newArray(2);
    arr->data[0] = newInteger((int) mousePos.x);
    arr->data[1] = newInteger((int) mousePos.y);

    return arr;
}

//-----------------------------------------------------------------------------
//set view border width
void doSetViewBorderWidth(void *v, int width) {
    //ensure layer
    ((NSView *) v).wantsLayer = YES;
    [((NSView *) v).layer setBorderWidth: width];
}

//-----------------------------------------------------------------------------
//create colour object
long long doCreateColour(float r, float g, float b, float a) {

    NSColor *myColour = [NSColor colorWithCalibratedRed: r
                                                  green: g
                                                  blue:  b
                                                  alpha: a ];
//    NSLog(@"Colour: %d %d %d %d: %lld", r, g, b, a, (long long) myColour);
    return (long long) myColour;
}

//-----------------------------------------------------------------------------
//set view background colour
void doSetViewBackgroundColour(void *v, void *c) {

//    NSLog(@"v: %lld to: %lld", (long long) v, (long long) c);
    //ensure we have a layer
    ((NSView *) v).wantsLayer = YES;

    //set it to the view's layer
    [((NSView *) v).layer setBackgroundColor: ((NSColor *) c).CGColor];
}

//-----------------------------------------------------------------------------
//set view border colour
void doSetViewBorderColour(void *v, void *c) {

    //ensure we have a layer
    ((NSView *) v).wantsLayer = YES;

    //set it to its border
    [((NSView *) v).layer setBorderColor: ((NSColor *) c).CGColor];
}

//-----------------------------------------------------------------------------
//set text colour
void doSetTextColour(void *v, void *c) {
    [(NSTextField *) v setTextColor: (NSColor *) c];
}

//-----------------------------------------------------------------------------
//set window resize
void doWindowResize(void *w, struct object *block) {
    [[NSNotificationCenter defaultCenter] addObserver: myDelegate selector: @selector(windowDidResize:) name: NSWindowDidResizeNotification object: myMainWindow];
//    NSLog(@"Window resize set");
}

//-----------------------------------------------------------------------------
//set frame for window
void doSetWindowFrame(void *w, int xc, int yc, int wc, int hc) {
    //create frame and set
//    NSLog(@"%lld %d %d %d %d", (long long) w, xc, yc, wc, hc);
    [(NSWindow *) w setFrame: NSMakeRect((float) xc, (float) yc, (float) wc, (float) hc) display: YES];
}

//-----------------------------------------------------------------------------
//set window title
void doSetWindowTitle(void *w, char *title) {
    [(NSWindow *) w setTitle: [NSString stringWithUTF8String: title]];
}

//-----------------------------------------------------------------------------
//center window
void doSetWindowCenter(void *w, char *title) {
    [(NSWindow *) w center];
}

//-----------------------------------------------------------------------------
//create view
long long doCreateView() {
    MyView * view = [[[MyView alloc] initWithFrame: CGRectZero] autorelease];
    view.wantsLayer = YES;
//    [view setAcceptResponder: YES];     //do we always want this??
//    NSLog(@"Created view %lld", (long long) view);
    return (long long) view;
}

//-----------------------------------------------------------------------------
//set control action block to be executed on e.g. button click
void doSetControlAction(void *w, struct object *block) {
//    NSLog(@"%p %p", w, block);
    [(NSControl *) w setAction: @selector(action:)];        //action: is the Obj-c message to the application delegate
}

//-----------------------------------------------------------------------------
//add view to window
void doAddViewToWindow(void *w, void *sub) {
//    NSLog(@"%p %p", w, sub);
    NSView *nw = [(NSWindow *)w contentView];
    [nw addSubview: (NSView *) sub];
}

//-----------------------------------------------------------------------------
//add subview to view
void doAddSubview(void *nw, void *sub) {
    [(NSView *) nw addSubview: (NSView *) sub];
}

//-----------------------------------------------------------------------------
//set frame for item w
void doSetFrame(void *w, int xc, int yc, int wc, int hc) {
    //create frame and set
//    NSLog(@"%lld %d %d %d %d", (long long) w, xc, yc, wc, hc);
    [(NSView *) w setFrame: NSMakeRect((float) xc, (float) yc, (float) wc, (float) hc)];
}

//-----------------------------------------------------------------------------
//get frame for item w
struct object *doGetFrame(void *w) {

    NSRect f = [(NSView *) w frame];

    //unpack and create array
    struct object *arr = newArray(4);
    arr->data[0] = newInteger((int) f.origin.x);
    arr->data[1] = newInteger((int) f.origin.y);
    arr->data[2] = newInteger((int) f.size.width);
    arr->data[3] = newInteger((int) f.size.height);
    return arr;
}

//-----------------------------------------------------------------------------
//create button
long long doCreateButton() {
    NSButton *button = [[[NSButton alloc] initWithFrame: CGRectZero] autorelease];
    [button setBezelStyle: NSBezelStyleRounded]; //Set what style You want (normal default)
    return (long long) button;
}

//-----------------------------------------------------------------------------
//set button title
void doSetButtonTitle(void *w, char *title) {
    [(NSButton *) w setTitle: [NSString stringWithUTF8String: title]];
}

//-----------------------------------------------------------------------------
//set button key equivalent
void doSetButtonKey(void *w, char *key) {
//  [c setKeyEquivalent:@"\r"];         //ENTER (default button)
//  [c setKeyEquivalent:@"\e"];         //ESC (cancel button)
    [(NSButton *) w setKeyEquivalent: [NSString stringWithUTF8String: key]];
}

//-----------------------------------------------------------------------------
//set button type
//0 = momentaryLight, 1 = pushOnOff, 2 = toggle, 3 = switch (checkbox), 4 = radio
//5 = momentaryChange, 6 = onOff, 7 = momentaryPushIn, 8 = accelerator, 9 = multilevel accelerator
void doSetButtonType(void *w, int type) {
    [(NSButton *) w setButtonType: type];
}

//-----------------------------------------------------------------------------
//set button style
//1=rounded, 2=regular square, 3= ?, 4= ?, 5=disclosure, 6=shadowless square, 7=circular, 8=textured square, 9=help,
//10=small square, 11=textured rounded, 12=roundrect, 13=recessed, 14=rounded disclosure, 15=inline
void doSetButtonStyle(void *w, int style) {
    [(NSButton *) w setBezelStyle: style];
}

//-----------------------------------------------------------------------------
//set button state
void doSetButtonState(void *w, int state) {
    if (state == 0) [(NSButton *) w setState: NSControlStateValueOff];
    else [(NSButton *) w setState: NSControlStateValueOn];
}

//-----------------------------------------------------------------------------
//get button state
int doGetButtonState(void *w) {
    return (int) [(NSButton *) w state];
}

//-----------------------------------------------------------------------------
//HELPER: common for textfields, boxes, and labels
NSTextField *textFieldCommon(int maxLines, BOOL editable, BOOL selectable) {

    NSTextField *textField = [[NSTextField alloc] initWithFrame: CGRectZero];

    [textField setBezeled: selectable];
    [textField setDrawsBackground: NO];
    [textField setEditable: editable];
    [textField setSelectable: selectable];
    if (maxLines > 1) {
        [textField setUsesSingleLineMode: NO];
        [textField setMaximumNumberOfLines: maxLines];
    } else {
        [textField setUsesSingleLineMode: YES];
        [textField setMaximumNumberOfLines: 1];
    }

//    [textField setDelegate: myDelegate];

    return textField;
}

//-----------------------------------------------------------------------------
//create label
long long doCreateLabel() {
    return (long long) textFieldCommon(1, NO, NO);
}

//-----------------------------------------------------------------------------
//create textfield/box
long long doCreateTextBox(int maxLines) {

    NSTextField *t = textFieldCommon(maxLines, YES, YES);

    //create mechanism for knowing when something happens
    [t setDelegate: myDelegate];

    return (long long) t;
}

//-----------------------------------------------------------------------------
//set control string value (not title)
void doSetControlString(void *w, char *s) {
    [(NSControl *) w setStringValue: [NSString stringWithUTF8String: s]];
}

//-----------------------------------------------------------------------------
//get control string value (not title)
char * doGetControlString(void *w) {
    return (char *) [[(NSControl *) w stringValue] UTF8String];
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//close the app
void doAppClose() {
    [NSApp terminate: NSApp];
}

//-----------------------------------------------------------------------------
//start the app
void doAppRun() {
     @autoreleasepool {
        [NSApp run];     //never returns
     }
}


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//HELPER: find string in array values
int arrLookup(struct object *arr, char *what) {
    int siz = SIZE(arr);
    int len = strlen(what);

    for (int i = 0; i < siz; i++) {
//        printf("var: %*s\n", SIZE(arr->data[i]), bytePtr(arr->data[i]));
        if (strncmp(what, (char *) bytePtr(arr->data[i]), len) == 0) return i;
    }
//    printf("\n");
    //fail with -1
    return -1;
}

//HELPER: get named instance variable from class (instanced object)
struct object *getVariable(struct object *from, char *name) {

    struct object *vars = (CLASS(from))->data[variablesInClass];     //KH: from is an instance

    if (NOT_NIL(vars)) {
        int thisOne = arrLookup(vars, name);
        if (thisOne < 0) {
//            printf("not found in get: %s\n", name);
            return nilObject;
        };
        //determine offset. First get the parent class to determine the right initial offset.
        struct object *parentClass = (CLASS(from))->data[parentClassInClass];

        int parentInstanceSize = integerValue(parentClass->data[instanceSizeInClass]);

        int offset = parentInstanceSize+thisOne;

//        printf("GET: Found: %s at offset: %d (thisOne: %d, parentInstanceSize: %d)\n", name, offset, thisOne, parentInstanceSize);
        if (offset < SIZE(from)) {
            return from->data[offset];
        } else {
            return nilObject; // could fall through
        }
    }
    return nilObject;
}

//HELPER: set named instance variable from class (instanced object). Returns 0 on failure, 1 success
int setVariable(struct object *from, char *name, struct object *value) {

    struct object *vars = (CLASS(from))->data[variablesInClass];     //KH: from is an instance
    if (NOT_NIL(vars)) {
        int thisOne = arrLookup(vars, name);
        if (thisOne < 0) {
//            printf("not found in set: %s\n", name);
            return 0;
        }
        struct object *parentClass = (CLASS(from))->data[parentClassInClass];
        int parentInstanceSize = integerValue(parentClass->data[instanceSizeInClass]);
        int offset = thisOne + parentInstanceSize;
//        printf("SET: Found: %s at offset: %d (thisOne: %d, parentInstanceSize: %d)\n", name, offset, thisOne, parentInstanceSize);
        if (offset < SIZE(from)) {
            from->data[offset] = value;
            return 1;
        } else {
            return 0; // could fall through
        }
    }
    return 0;
}

//HELPER: get named class variable in named class. Return nilObject on failure
struct object *getClassVariable(char *className, char *varName) {
    //get class
    struct object *class = lookupGlobal(className);
    //get its metaclass
    struct object *meta = class->class;
    //get variable
    struct object *classVars = meta->data[variablesInClass];
    //which one is it? nil on failure...
    int thisOne = arrLookup(classVars, varName);
    if (thisOne < 0) return nilObject;
    //get variable in class
    return class->data[ClassSize + thisOne];
}

//HELPER: set named class variable in named class. Return 0 on failure, 1 success
int setClassVariable(char *className, char *varName, struct object *value) {
    //get class
    struct object *class = lookupGlobal(className);
    //get its metaclass
    struct object *meta = class->class;
    //get variable
    struct object *classVars = meta->data[variablesInClass];
    int thisOne = arrLookup(classVars, varName);
    if (thisOne < 0) return 0;
    //set variable in class
    class->data[ClassSize + thisOne] = value;
    return 1;
}

//HELPER: create string object
struct object *newString(char *s) {
    int len = strlen(s);
    struct byteObject *ba = (struct byteObject *) gcialloc(len);
    ba->class = ByteArrayClass;

    /* copy data into the new ByteArray */
    for(int j = 0; j < len; j++) {
        bytePtr(ba)[j] = s[j];
    }

    ba->class = StringClass;
    return (struct object *) ba;
}

//HELPER: create array object
struct object *newArray(int size) {
    struct object *result = gcalloc(size);
    result->class = lookupGlobal("Array");
    for (int i = 0; i < size; ++i) {
        result->data[i] = nilObject;
    }
    return result;
}

//-----------------------------------------------------------------------------
//init GUI Cocoa app
void initMacGUI() {

    //crucial
    [NSApplication sharedApplication];

    myDelegate = [[MyAppDelegate new] autorelease];
    [myDelegate makeMainWindow];
    [myDelegate makeKeyWindow];
    [NSApp setDelegate: myDelegate];

//    [NSApp setDelegate: [appdelegate new]];
//    [NSApp setDelegate: [SpecialDelegate new]];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    //Get directory info
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex: 0];
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *exPath = [myBundle executablePath];
    NSString *resPath = [myBundle resourcePath];

    //get its variables and set the variables
    char ptr[40] = "";
    sprintf(ptr, "%lld", (long long) NSApp);

    setClassVariable("MacApp", "mainWindow", newLInteger((long long) myMainWindow));
    setClassVariable("MacApp", "pointer", newString(ptr));
    setClassVariable("MacApp", "documentDirectory", newString((char *)[documentsDirectoryPath UTF8String]));
    setClassVariable("MacApp", "homeDirectory", newString((char *)[NSHomeDirectory() UTF8String]));
    setClassVariable("MacApp", "executableDirectory", newString((char *)[exPath UTF8String]));
    setClassVariable("MacApp", "resourceDirectory", newString((char *)[resPath UTF8String]));

//
//     NSString *startup = [myBundle pathForResource:@"startup4" ofType:@"s"];          //default is where resource is
//
//     if ([fileManager fileExistsAtPath: startup] != YES) {
//         //if not there, perhaps in the documents directory?
//         startup = [documentsDirectoryPath stringByAppendingPathComponent:@"startup4.s" ];
//     }

//     const char *startFile = GC_MALLOC(FILENAME_MAX);
//     startFile = [startup UTF8String];
//     iniFile = (char *) startFile;
//
//     //store mainScreenFrame for later use
//     NSRect mf = [[NSScreen mainScreen] frame];
//
//     NSRect *nf = GC_MALLOC(sizeof(NSRect));
//     memcpy(nf, &mf, sizeof(NSRect));
//     Bytecode *c = GC_MALLOC(sizeof(Bytecode));
//     c->value.pointer = (void *) nf;
//     application->vars = insertInTree("mainScreenFrame", simpleObject(c, "Frame"), application->vars);
//
//     //event table
//     event = GC_MALLOC(100 * sizeof(Tree *));

    // Since we are no real UI application by now and since we have
    // no Info.plist, we must programmatically become a UI process,
    // which is in fact possible!!!!
    //see: https://stackoverflow.com/questions/2724482/catching-multiple-keystrokes-simultaneously-in-cocoa/2731166#2731166

    ProcessSerialNumber myProcess = { 0, kCurrentProcess };
    TransformProcessType(
        &myProcess,
        kProcessTransformToForegroundApplication
    );

//    NSLog(@"App started!");

    return;
}


//-----------------------------------------------------------------------------
//INITIALISE gui environment -- all the stuff that really needs this environment
// @implementation SpecialDelegate           //delegate and initialisation stuff
//
// @end



@implementation MyAppDelegate           //delegate and initialisation stuff

//HELPER target for stuff : no argument but sender. MacOS calls this if the action: is set as being triggered on an event
- (void) action: (id) sender {

    //check if we have an action for this sender
    struct object *actionTable = getClassVariable("MacApp", "actionTable");

    if (!NOT_NIL(actionTable)) {
//        NSLog(@"No actionTable");
        return;
    }

    char ptr[40] = "";
    sprintf(ptr, "%lld", (long long) sender);

    struct object *myProcess = dictLookup(actionTable, ptr);
//    NSLog(@"Sender: %lld (ptr: %s) process: %p", (long long) sender, ptr, myProcess);

    //if nothing specified, just get out
    if (!NOT_NIL(myProcess)) return;

    /* protect the Process from GC */
    rootStack[rootTop++] = myProcess;

    if(myProcess != rootStack[rootTop-1]) {
       myProcess = rootStack[rootTop-1];
       /* load anything else you need from the Process */
    }

    //... build Context ...
    struct object *myContext = myProcess->data[contextInProcess];

    //set into arg array item 4!
    struct object *argArray = myContext->data[argumentsInContext];
    argArray->data[2] = newString(ptr);

    rootStack[rootTop++] = myContext;

    //execute the Process
    int ret = execute(myProcess, 0);

//    NSLog(@"Result of exec was: %d", ret);

    struct object *context = rootStack[--rootTop];
    struct object *process = rootStack[--rootTop];

    process->data[contextInProcess] = context;
    context->data[bytePointerInContext] = newInteger(0);
    context->data[stackTopInContext] = newInteger(0);

}

//NOTIFICATION actions: sender and notification name
- (void) noteAction: (id) sender name: (id) noteName {

//    NSLog(@"Notification: %@", noteName);

    //check if we have an action for this sender
    struct object *actionTable = getClassVariable("MacApp", "notificationTable");

    if (!NOT_NIL(actionTable)) {
//        NSLog(@"No notificationTable");
        return;
    }

    char ptr[40] = "";
    sprintf(ptr, "%lld", (long long) sender);

    struct object *myProcess = dictLookup(actionTable, ptr);
//    NSLog(@"Sender: %lld (ptr: %s) process: %p", (long long) sender, ptr, myProcess);

    //if nothing specified, just get out
    if (!NOT_NIL(myProcess)) return;

    /* protect the Process from GC */
    rootStack[rootTop++] = myProcess;

    if(myProcess != rootStack[rootTop-1]) {
       myProcess = rootStack[rootTop-1];
       /* load anything else you need from the Process */
    }

    //... build Context ...
    struct object *myContext = myProcess->data[contextInProcess];

    //get notification name as char *
    char *name = (char *) [noteName UTF8String];
    //create LST string
    struct object *nameObject = newString(name);
    //set into arg array item 4!
    struct object *argArray = myContext->data[argumentsInContext];
    argArray->data[3] = nameObject;

    //save context
    rootStack[rootTop++] = myContext;

    //execute the Process
    int ret = execute(myProcess, 0);

//    NSLog(@"Result of exec was: %d", ret);

    struct object *context = rootStack[--rootTop];
    struct object *process = rootStack[--rootTop];

    process->data[contextInProcess] = context;
    context->data[bytePointerInContext] = newInteger(0);
    context->data[stackTopInContext] = newInteger(0);

}

//NOTIFICATION actions: sender, notification, and item
- (void) noteAction: (id) sender name: (id) noteName item: (id) item {

//IMPLEMENT LATER; NEEDED FOR D&D

}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) sender {
    return YES;
};

//ensure app closes when quit
- (NSApplicationTerminateReply) applicationShouldTerminate: (NSApplication *) sender {
    return NSTerminateNow;
};

- (void) windowDidResize: (NSNotification *) aNotification {
//    NSLog(@"Window did resize");
    id sender = [aNotification object];
    id name =[aNotification name];
    [myDelegate noteAction: sender name: name];
}

- (void) applicationWillFinishLaunching: (NSNotification *) aNotification {
    // make the window visible when the app is about to finish launching //
    [myMainWindow makeKeyAndOrderFront: self];
    // do layout and cool stuff here
    //pass on to noteAction if there is an action: method for Application
    //note to check the name if you have several notifications!
    id sender = [aNotification object];
    id name =[aNotification name];
    [myDelegate noteAction: sender name: name];
}

- (void) applicationWillTerminate: (NSNotification *) aNotification {
    // tear down stuff here
    //pass on to noteAction if there is an action: method for Application
    //note to check the name if you have several notifications!
    id sender = [aNotification object];
    id name =[aNotification name];
    [myDelegate noteAction: sender name: name];
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {
    // initialize your code stuff here
    //pass on to noteAction if there is an action: method for Application
    //note to check the name if you have several notifications!
    id sender = [aNotification object];
    id name =[aNotification name];
    [myDelegate noteAction: sender name: name];
}


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//INIT APP
- (instancetype) init {
    //Pick your window style:
    NSUInteger windowStyle = NSWindowStyleMaskTitled | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable;

    NSRect r = NSMakeRect(0, 0, 300, 200);
    myMainWindow = [super initWithContentRect: r styleMask: windowStyle backing: NSBackingStoreBuffered defer: NO];
    [self setTitle: @"MAIN"];
    [self setIsVisible: YES];

    window = myMainWindow;      //save for later use
    [window center];
    window.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;

    return self;
}

//-----------------------------------------------------------------------------
//DEINIT app
- (void) dealloc {
    // release your window and other stuff //
    [window release];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

//TEXTFIELD delegate
- (void) controlTextDidEndEditing: (NSNotification *) aNotification {
    id sender = [aNotification object];
    id name =[aNotification name];
    [self noteAction: sender name: name];
};

- (void) controlTextDidChange: (NSNotification *) aNotification {
    id sender = [aNotification object];
    id name =[aNotification name];
    [self noteAction: sender name: name];
};

- (void) controlTextDidBeginEditing: (NSNotification *) aNotification {
     id sender = [aNotification object];
     id name =[aNotification name];
     [self noteAction: sender name: name];
};

- (void) comboBoxSelectionDidChange: (NSNotification *) aNotification {
    id sender = [aNotification object];
    id name =[aNotification name];
    [self noteAction: sender name: name];
}

//DRAGGING SOURCE
- (NSDragOperation) draggingSession: (NSDraggingSession *) session sourceOperationMaskForDraggingContext: (NSDraggingContext) context {
    NSLog(@"Drag source start");
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingSourceOperationMaskForLocal: (BOOL) isLocal {
    NSLog(@"Drag source mask");
    if (!isLocal){
        return NSDragOperationCopy;//destination object is in a different application.
    } else {
        return NSDragOperationNone;
    }
}

@end
