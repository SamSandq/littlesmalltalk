//
// Part of Little Smalltalk MacGUI implementation
// copyright (c) Sam Sandqvist 2023
//
// see LICENCE file for details
//

#include "globals.h"
#include "interp.h"
#include "memory.h"
#include "err.h"
#include "prim.h"
#include "mac_gui.h"

void getUnixString(char * to, int size, struct object * from);

//#define longIntegerValue(x)     (long long)(x->data[0])
#define longIntegerValue(x)     *(int64_t *)bytePtr(x)

struct object *mac_primitive(int primitiveNumber, struct object *args, int *failed) {

    //important to set NOT failed initially!
    *failed = 0;

    char stringBuffer[255] = "";
    char stringBuffer2[255] = "";

    if (primitiveNumber != 250) return nilObject;   /* SSQ+ these are for GUI primitives */

    //all have the form <300 subPrim self arg1 arg2 ....>

    int subPrim = integerValue(args->data[0]);      //get the subprimitive

    //default is returning self, passed in for just that purpose (otherwise cascade won't work)
    //however, when creating new elements we return the new one as a pointer (long long), not self
    struct object *returnedValue = args->data[1];

    //the big switch based on the subroutine we want to run
    switch (subPrim) {
        case 0:                 //init GUI  <250 0 self>
            initMacGUI();
            break;
        case 1:                 //start the app     <250 1 self>
            doAppRun();         //never returns, so do this LAST
            break;
        case 2:                 //set window title  <250 2 self window title>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[3]);
            doSetWindowTitle(longIntegerValue(args->data[2]), stringBuffer);
            break;
        case 3:                 //set window frame  <250 3 self window x y width height>
            doSetWindowFrame(longIntegerValue(args->data[2]),
                integerValue(args->data[3]), integerValue(args->data[4]), integerValue(args->data[5]), integerValue(args->data[6]));
            break;
        case 4:                 //center window     <250 4 self>
            doSetWindowCenter(longIntegerValue(args->data[2]));
            break;
        case 5:                 //add view to window <250 5 self window view>
            doAddViewToWindow(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 6:                 //stop the app     <250 6 self>
            doAppClose();
            break;
        case 7:                 //get resize notifications <250 7 self window block>
            doWindowResize(longIntegerValue(args->data[2]), args->data[3]);
            break;
        case 8:                 //get frame info (array) for object <250 8 self pointer>
            returnedValue = doGetFrame(longIntegerValue(args->data[2]));
            break;
        case 9:                 //create new window <250 9 self>
            returnedValue = newLInteger( doCreateWindow());
            break;
        case 10:                //set view frame     <250 10 self pane x y width height>
            doSetFrame(longIntegerValue(args->data[2]),
                integerValue(args->data[3]), integerValue(args->data[4]), integerValue(args->data[5]), integerValue(args->data[6]));
            break;
        case 11:                //add subview to view   <250 11 self pane pane>
            doAddSubview(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 12:                //create view
            returnedValue = newLInteger( doCreateView() );
            break;
        case 13:                //set pane border width <250 13 self pane width>
            doSetViewBorderWidth(longIntegerValue(args->data[2]), integerValue(args->data[3]));
            break;
        case 14:                //show previously created window (not for main!)
            doShowWindow(longIntegerValue(args->data[2]));
            break;
        case 15:                //close previously created window. This disposes of it too
            doCloseWindow(longIntegerValue(args->data[2]));
            break;
        case 16:                //set focus to view in window
            doSetFocus(longIntegerValue(args->data[2]));
            break;
        case 17:                //hide/show view 0 hide, 1 show
            doSetShowView(longIntegerValue(args->data[2]), integerValue(args->data[3]));
        case 18:                //get hidden status
            returnedValue = doGetHiddenStatus(longIntegerValue(args->data[2]));
            break;
        case 19:                //remove view
            doRemoveView(longIntegerValue(args->data[2]));
            break;
        case 20:                //create button     <250 20 self>
            returnedValue = newLInteger( doCreateButton());
            break;
        case 21:                //set button title
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[3]);
            doSetButtonTitle(longIntegerValue(args->data[2]), stringBuffer);
            break;
        case 22:                //set button key
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[3]);
            doSetButtonKey(longIntegerValue(args->data[2]), stringBuffer);
            break;
        case 23:                //set control action        <250 23 self control block>
            doSetControlAction(longIntegerValue(args->data[2]), args->data[3]);
            break;
        case 24:                //set control string
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[3]);
            doSetControlString(longIntegerValue(args->data[2]), stringBuffer);
            break;
        case 25:                //get control string
            returnedValue = newString( doGetControlString(longIntegerValue(args->data[2])));
            break;
        case 26:                //set button style
            doSetButtonStyle(longIntegerValue(args->data[2]), integerValue(args->data[3]));
            break;
        case 27:                //set button type
            doSetButtonType(longIntegerValue(args->data[2]), integerValue(args->data[3]));
            break;
        case 28:                //set button state
            doSetButtonState(longIntegerValue(args->data[2]), integerValue(args->data[3]));
            break;
        case 29:                //get button state
            returnedValue = newLInteger( doGetButtonState(longIntegerValue(args->data[2])) );
            break;
        case 30:                //create label      <250 30 self>
            returnedValue = newLInteger( doCreateLabel() );
            break;
        case 31:                //create textbox    <250 31 self lines>
            returnedValue = newLInteger( doCreateTextBox(integerValue(args->data[2])) );
            break;
        case 40:                //create colour     <250 40 self + args 2, 3, 4, 5: r. g. b. a
            returnedValue = newLInteger( doCreateColour((float) integerValue(args->data[2])/255, (float) integerValue(args->data[3])/255,
                (float) integerValue(args->data[4])/255, (float) integerValue(args->data[5])/255 ));
            break;
        case 41:                //set pane background colour    <250 41 self pane colour>
            doSetViewBackgroundColour(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 42:                //set pane border colour    <250 42 self pane colour>
            doSetViewBorderColour(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 43:                //set text colour    <250 43 self textitem colour>
            doSetTextColour(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 50:                //get mouse position in window, as Array x,y    <250 50 self>
            returnedValue = doGetMousePositionInWindow();
            break;
        case 60:                //create font   <250 60 self name size bold italic>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            returnedValue = newLInteger( doCreateFont(stringBuffer,
                integerValue(args->data[3]), integerValue(args->data[4]), integerValue(args->data[5]) ) );
            break;
        case 61:                //set font      <250 61 self item font>
            doSetFont(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 70:                //(create) and get main menu bar <250 70 self>
            returnedValue = newLInteger( doGetMenubar() );
            break;
        case 71:                //create named menu             <250 71 self title>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            returnedValue = newLInteger( doCreateMenu(stringBuffer) );
            break;
        case 72:                //create menu item              <250 72 self key title>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            returnedValue = newLInteger( doCreateMenuItem(stringBuffer2, stringBuffer) );
            break;
        case 73:                //create menu item separator
            returnedValue = newLInteger( doCreateMenuItemSeparator());
            break;
        case 74:                //set menu as submenu to another menu
            doSetMenuAsSubmenuForItem(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]), longIntegerValue(args->data[4]));
            break;
        case 75:                //add item to menu
            doAddMenuItem(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 76:                //add menu directly to view (context menu)
            doAddMenuToView(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        default:
            error("Unknown GUI primitive: %d!", subPrim);
            break;
    }

    return returnedValue;
}

void getUnixString(char * to, int size, struct object * from) {
    int i = 0;
    int fsize = SIZE(from);
    struct byteObject * bobj = (struct byteObject *) from;

    if (fsize >= size) {
        error("getUnixString(): String too long, %d, for buffer, %d bytes!", fsize, size);
    }

    for (i = 0; i < fsize; i++) {
        to[i] = (char)bobj->bytes[i];
    }

    to[i] = '\0';	/* put null terminator at end */
}
