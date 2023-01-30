//
// Part of Little Smalltalk MacGUI implementation
// copyright (c) Sam Sandqvist 2023
//
// see LICENCE file for details
//

#include <stdlib.h>
#include <string.h>
#include "globals.h"
#include "interp.h"
#include "memory.h"
#include "err.h"
#include "prim.h"
#include "mac_gui.h"

//these are from prim.c
#define FILEMAX 200
extern FILE *filePointers[];

void getUnixString(char * to, int size, struct object * from);

//#define longIntegerValue(x)     (long long)(x->data[0])
//#define longIntegerValue(x)     *(int64_t *)bytePtr(x)

struct object *mac_primitive(int primitiveNumber, struct object *args, int *failed) {

    Object *returnedValue;
    int i;
    FILE *fp;
    int unsigned fLen;

    //important to set NOT failed initially!
    *failed = 0;

    char stringBuffer[1024] = "";
    char stringBuffer2[1024] = "";
    char stringBuffer3[1024] = "";
    char stringBuffer4[1024] = "";

    //we have some with other than 250...
    if (primitiveNumber != 250) {
        switch (primitiveNumber) {
            case 251:       //get string format of Time     <251 timestamp> obtained by e.g. <161>
                returnedValue = doStringDateTime(args->data[0]);
                break;
            case 252:       //get length of file            <252 fileId>
                i = integerValue(args->data[0]);
                if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
                    *failed = 1;
                    break;
                }
                fseek(fp, 0, SEEK_END);
                fLen = ftell(fp);
                returnedValue = newInteger( fLen );
                fseek(fp, 0, SEEK_SET);
                break;
            case 253:       //find substring. 0 not found, >1 pos
                getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[0]);
                getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[1]);
                {
                    int pos = 0;
                    int from = integerValue(args->data[2]);
                    if (strlen(stringBuffer2) < strlen(stringBuffer + from-1)) {
                        char *where = strstr(stringBuffer + from-1, stringBuffer2);
                        pos = (where != NULL)? where - stringBuffer + 1: 0;
                    };
                    returnedValue = newInteger(pos);
                }
                break;
            case 254:       //copyFile <254 to from>
                getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[0]);
                getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[1]);
                returnedValue = newInteger(doCopyFile(stringBuffer, stringBuffer2));
                break;
            case 255:       //command(s)    <255 s>
                getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[0]);
                returnedValue = newInteger(system(stringBuffer));
                break;
            default:
                returnedValue = nilObject;
                break;
        }

//NOT USED  case 2xx:   numberOfTempsInBlock    <2xx block>
//             {
//                 Object *block = args->data[0];
//                 Object *tempArr = block->data[temporariesInBlock];
//                 int high = integerValue(block->data[argumentLocationInBlock]);
//                 int sz = (tempArr ? ((int)SIZE(tempArr) - high) : 0);
//     //            printf("Args (high: %d): %d\n", high, sz);
//                 returnedValue = newInteger(sz);
//             }


        return returnedValue;   /* 250: SSQ+ these are for GUI primitives */
    }
    //all have the form <250 subPrim self arg1 arg2 ....>

    int subPrim = integerValue(args->data[0]);      //get the subprimitive

    //default is returning self, passed in for just that purpose (otherwise cascade won't work)
    //however, when creating new elements we return the new one as a pointer (long long), not self
    returnedValue = args->data[1];

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
//         case 40:                //create colour     <250 40 self + args 2, 3, 4, 5: r. g. b. a
//             returnedValue = newLInteger( doCreateColour((float) integerValue(args->data[2])/255, (float) integerValue(args->data[3])/255,
//                 (float) integerValue(args->data[4])/255, (float) integerValue(args->data[5])/255 ));
//             break;
        case 41:                //set pane background colour    <250 41 self pane colour>
            doSetViewBackgroundColour(longIntegerValue(args->data[2]), args->data[3]);
            break;
        case 42:                //set pane border colour    <250 42 self pane colour>
            doSetViewBorderColour(longIntegerValue(args->data[2]), args->data[3]);
            break;
        case 43:                //set text colour    <250 43 self textitem colour>
            doSetTextColour(longIntegerValue(args->data[2]), args->data[3]);
            break;
        case 44:                //get view colour   <250 44 self pane>
            returnedValue =  doGetBackgroundColour(longIntegerValue(args->data[2]));
            break;
//         case 45:                //get colour as Array   <250 45 self colour>
//             returnedValue = doColourAsArray(longIntegerValue(args->data[2]));
//             break;
        case 46:                //create colourPanel    <250 46 self>
            returnedValue = newLInteger(doColourPanel());
            break;
        case 47:                //show/hide colour panel    <250 47 self pane int>
            doShowColourPanel(longIntegerValue(args->data[2]), integerValue(args->data[3]));
            break;
        case 48:                //get colour panel colour   <250 48 self pane>
            returnedValue = doGetColourFromPanel(longIntegerValue(args->data[2]));
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
        case 77:
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            returnedValue = newLInteger(doCreateMenuItemCut(stringBuffer2, stringBuffer));
            break;
        case 78:
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            returnedValue = newLInteger(doCreateMenuItemCopy(stringBuffer2, stringBuffer));
            break;
        case 79:
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            returnedValue = newLInteger(doCreateMenuItemPaste(stringBuffer2, stringBuffer));
            break;
        case 790:
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            returnedValue = newLInteger(doCreateMenuItemSelectAll(stringBuffer2, stringBuffer));
            break;
        case 80:                //scrollview        <250 80 self>
            returnedValue = newLInteger( doCreateScrollView() );
            break;
        case 81:                //add view to scrollview    <250 81 self scrollpointer viewpointer>
            doAddViewToScrollView(longIntegerValue(args->data[2]), longIntegerValue(args->data[3]));
            break;
        case 82:                //get scrollview rectangle  <250 82 self scrollpointer>
            returnedValue = doScrollViewRect(longIntegerValue(args->data[2]));
            break;
        case 90:                //alert panel <250 90 self title message style button1 button2>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            getUnixString(stringBuffer3, sizeof(stringBuffer3)-1, args->data[5]);
            getUnixString(stringBuffer4, sizeof(stringBuffer4)-1, args->data[6]);
            returnedValue = newLInteger( doAlertPanel(stringBuffer, stringBuffer2, integerValue(args->data[4]), stringBuffer3, stringBuffer4) );
            break;
        case 91:                //open panel    <250 91 self type multi dir>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            returnedValue = doOpenPanel(stringBuffer, integerValue(args->data[3]), integerValue(args->data[4]));
            break;
        case 92:                //save panel    <250 92 self default>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            {
                char * res = doSavePanel(stringBuffer);
                if (res == NULL) returnedValue = newString("");
                else returnedValue = newString(res);
             }
            break;
        case 100:               //create image pane <250 100 self>
            returnedValue = newLInteger( doCreateImageView() );
            break;
        case 101:               //set image to imageview    <250 101 self pane imagedata length scaling>
            {
            struct byteObject *buff = (struct byteObject *) args->data[3];
            unsigned int sz = SIZE(buff);
            void *ptr = malloc(sz+1);
            if (ptr == NULL) error("Cannot allocate temporary buffer for image size: %d", sz);
            getUnixString(ptr, sz+1, (Object *) buff);
            doSetImage(longIntegerValue(args->data[2]), ptr, integerValue(args->data[4]), integerValue(args->data[5]));
            free(ptr);
            }
            break;
        case 102:               //set image from file   <250 102 self pane fileName scaling>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[3]);
            doSetImageFromFile(longIntegerValue(args->data[2]), stringBuffer, integerValue(args->data[4]));
            break;
        case 110:               //corners for a view    <250 110 self pane radius>
            doCornerView(longIntegerValue(args->data[2]), integerValue(args->data[3]));
            break;
        case 111:               //shadow for a view     <250 111 self pane radius opacity>      NB: opacity in percent
            doShadowView(longIntegerValue(args->data[2]), integerValue(args->data[3]), integerValue(args->data[4]));
            break;
        case 120:               //Timer after: <secs> action: aBlock    <250 120 self secs>
            doTimerAction(integerValue(args->data[2]));
            break;
        case 200:               //create directory      <250 200 self dirName> returns 0 on failure 1 otherwise
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            returnedValue = newInteger( doCreateDirectory(stringBuffer) );
            break;
        case 201:              //renameFile <250 201 self to from>
            getUnixString(stringBuffer, sizeof(stringBuffer)-1, args->data[2]);
            getUnixString(stringBuffer2, sizeof(stringBuffer2)-1, args->data[3]);
            returnedValue = newInteger(doRenameFile(stringBuffer, stringBuffer2));
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
