# GMAssert
Assertion scripts for GameMaker Studio 1.x

## Introduction
GMAssert is a library containing useful assertions for debugging and automated unit testing. You can use it to alert you to undesirable runtime conditions and pause the debugger at that point for further inspection.

## Requirements
- GameMaker Studio 1.4 or above

## Installation
Simply drag GMAssert.gml into your open project and import constants.txt as macros. If you wish to use the debugger, open `__GMA_BREAKPOINT__` and place a breakpoint on the marked line.

## Contributing to GMAssert
+ Clone both `gmassert` and `gmassert-workbench`.
+ Open the workbench in GameMaker Studio and make your additions/changes to the `gmassert` script group. Also add corresponding tests to the `gmassert_test` script group.
+ Export the `gmassert` script group to `gmassert-workbench`, overwriting its copy of `gmassert.gml`.
+ Open a pull request on both `gmassert` and `gmassert-workbench`.
