//external declarations for GUI

//
// Part of Little Smalltalk MacGUI implementation
// copyright (c) Sam Sandqvist 2023
//
// see LICENCE file for details
//

#pragma once

typedef struct object Object;
#define longIntegerValue(x)     (long long) (x->data[0])    //*(int64_t *)bytePtr(x)

//extern struct object *newLInteger(int64_t val);

extern Object *newLInteger();

extern void initMacGUI();
extern struct object *getClassVariable();
extern struct object *getVariable();
extern int setVariable();
extern struct object *newString();
extern struct object *newArray();
extern Object *doStringDateTime();
extern int execute();
extern void doAppRun();
extern void doAppClose();
extern void doWindowResize();
extern void doSetWindowTitle();
extern void doSetWindowFrame();
extern void doSetWindowCenter();
extern void doSetFocus();
extern void doSetFrame();
extern struct object *doGetFrame();
extern void doAddViewToWindow();
extern void doAddSubview();
extern void doSetShowView();
extern struct object *doGetHiddenStatus();
extern void doRemoveView();
extern void doSetButtonTitle();
extern void doSetButtonKey();
extern void doSetButtonType();
extern void doSetButtonStyle();
extern void doSetButtonState();
extern int doGetButtonState();
extern long long doCreateWindow();
extern void doShowWindow();
extern void doCloseWindow();
extern long long doCreateButton();
extern long long doCreateView();
extern void doSetControlAction();
extern long long doCreateLabel();
extern long long doCreateTextBox();
extern void doSetControlString();
extern char *doGetControlString();
extern long long doCreateColour(float, float, float, float);
extern void doSetViewBackgroundColour();
extern long long doGetBackgroundColour();
extern void doSetViewBorderColour();
extern void doSetTextColour();
extern void doSetViewBorderWidth();
extern struct object *doGetMousePositionInWindow();
extern long long doCreateFont();
extern void doSetFont();
extern long long doCreateMenu();
extern long long doGetMenubar();
extern long long doCreateMenuItem();
extern long long doCreateMenuItemCopy();
extern long long doCreateMenuItemPaste();
extern long long doCreateMenuItemCut();
extern long long doCreateMenuItemSelectAll();
extern long long doCreateMenuItemSeparator();
extern void doAddMenuItem();
extern void doAddMenuToView();
extern void doSetMenuAsSubmenuForItem();
extern long long doCreateScrollView();
extern void doAddViewToScrollView();
extern int doAlertPanel();
extern char *doSavePanel();
extern Object *doOpenPanel();
extern long long doCreateImageView();
extern void doSetImage();
extern Object *doColourAsArray();
extern void doCopyFile();
extern void doFlipView();
extern void doCornerView();
extern void doShadowView();
extern Object *doScrollViewRect();
extern long long doColourPanel();
extern void doShowColourPanel();
extern long long doGetColourFromPanel();

