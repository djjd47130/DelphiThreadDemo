# JD Thread Demo

This application demonstrates the usage of threads in Delphi. Since there are many different things to know, they are divided into different sections for different purposes. Each topic has at least 1 form unit (embedded into a tab sheet), and at least 1 stand-alone unit containing its functionality apart from the user interface. This is done on purpose, to show that threads *should* be isolated from any UI.

The main form itself does not actually have any logic in it. All it does is embeds the forms into tabs. In the `FormCreate()` event handler, it makes numerous calls to `EmbedForm()` which instantiates a form for each tab sheet. 

Actually using the application is very simple. You just navigate to one of the tabs, and each one will have its own instructions. 

## Downloading

Shows how a file can be downloaded from the internet in a thread. There is a single universal function defined `DownloadFile()` which performs the download. The UI has 3 buttons:

  - Download Without Thread
  - Download With Thread Class
  - Download With Anonymous Thread

By default, the URL to be downloaded is a test file provided by ThinkBroadband.com, but you can use any URL you wish. You can also choose the location to save the file to. This is a very simple demo, so the filename/extension of the local filename needs to be adjusted to your needs - it won't automatically change for the URL you're downloading (as browsers typically do). 

## Progress Bar

Shows how to update a progress bar from a thread which is performing a lengthy task.

## Critical Sections



