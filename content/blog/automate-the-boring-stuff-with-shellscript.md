+++
title = 'Automate the Boring Stuff With Shellscript'
description = "Automate the Boring Stuff With Shellscript"
date = 2025-05-29T19:14:27+07:00
draft = true
tags = []
author = "anhkhoakz"
+++

---

This blog is a clone of [Automate the Boring Stuff with Python](https://automatetheboringstuff.com/) but with shellscript, specifically for Bash version 5 and works on Linux and macOS.

## Table of Contents

- [Introduction](#introduction)
- [Chapter 1 - Bash Basics](#chapter-1--bash-basics)
- [Chapter 2 - Flow Control](#chapter-2--flow-control)
- [Chapter 3 - Functions](#chapter-3--functions)
- [Chapter 4 - Lists](#chapter-4--lists)
- [Chapter 5 - Dictionaries and Structuring Data](#chapter-5--dictionaries-and-structuring-data)
- [Chapter 6 - Manipulating Strings](#chapter-6--manipulating-strings)
- [Chapter 7 - Pattern Matching with Regular Expressions](#chapter-7--pattern-matching-with-regular-expressions)
- [Chapter 8 - Input Validation](#chapter-8--input-validation)
- [Chapter 9 - Reading and Writing Files](#chapter-9--reading-and-writing-files)
- [Chapter 10 - Organizing Files](#chapter-10--organizing-files)
- [Chapter 11 - Debugging](#chapter-11--debugging)
- [Chapter 12 - Web Scraping](#chapter-12--web-scraping)
- [Chapter 13 - Working with Excel Spreadsheets](#chapter-13--working-with-excel-spreadsheets)
- [Chapter 14 - Working with Google Spreadsheets](#chapter-14--working-with-google-spreadsheets)
- [Chapter 15 - Working with PDF and Word Documents](#chapter-15--working-with-pdf-and-word-documents)
- [Chapter 16 - Working with CSV Files and JSON Data](#chapter-16--working-with-csv-files-and-json-data)
- [Chapter 17 - Keeping Time, Scheduling Tasks, and Launching Programs](#chapter-17--keeping-time-scheduling-tasks-and-launching-programs)
- [Chapter 18 - Sending Email and Text Messages](#chapter-18--sending-email-and-text-messages)
- [Chapter 19 - Manipulating Images](#chapter-19--manipulating-images)
- [Chapter 20 - Controlling the Keyboard and Mouse with GUI Automation](#chapter-20--controlling-the-keyboard-and-mouse-with-gui-automation)
- [Appendix A - Installing Third-Party Modules](#appendix-a--installing-third-party-modules)
- [Appendix B - Running Programs](#appendix-b--running-programs)
- [Appendix C - Answers to the Practice Questions](#appendix-c--answers-to-the-practice-questions)

## Chapter 9 - Reading and Writing Files

### The Current Working Directory

The current working directory is the folder that your shell is currently looking at. You can find out what it is by running the `pwd` command.

```bash
$ pwd
/Users/user/Documents
```

### The Home Directory

The home directory is the folder that contains your user account. You can find out what it is by running the `echo $HOME` command.

```bash
$ echo $HOME
/Users/user
```

---
