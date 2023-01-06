//external declarations for GUI

//
// Part of Little Smalltalk MacGUI implementation
// copyright (c) Sam Sandqvist 2023
//
// see LICENCE file for details
//

#pragma once

extern void initMacGUI();
extern struct object *getClassVariable();
extern struct object *getVariable();
extern int setVariable();
extern struct object *newString();
extern struct object *newArray();
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
extern void doSetViewBorderColour();
extern void doSetTextColour();
extern void doSetViewBorderWidth();
struct object *doGetMousePositionInWindow();
extern long long doCreateFont();
extern void doSetFont();
extern long long doCreateMenu();
extern long long doGetMenubar();
extern long long doCreateMenuItem();
extern long long doCreateMenuItemSeparator();
extern void doAddMenuItem();
extern void doAddMenuToView();
extern void doSetMenuAsSubmenuForItem();

