# DelphiThreadDemo
Demonstrating different ways to use threads in Delphi

![Thread](/ThreadIcon.png "Thread")

## Can I Use VCL From a Thread?

# NO!

Far too many Delphi users make the mistake of thinking a thread is some sort of magic that will improve the performance of their application. Unfortunately, this is far from true. The #1 biggest mistake when trying to implement a thread is making it directly access visual controls of the application. But these visual controls can only work in the context of the application's main thread. Using another thread to update controls in the user interface must be very carefully planned and implemented. And in most cases, it probably isn't the right solution to the problem at all.

Simply put, the VCL framework of Delphi is not thread safe. While there are many ways to integrate a thread into your UI, there is no single one-size-fits-all solution. It will always vary depending on what you are trying to accomplish. Most of the time, people want to accomplish better performance (speed). But that is very rarely ever done by using a thread. Instead, the most common scenarios where a thread is integrated into a user interface is to keep that UI responsive during a long task.

Let's take a look at what a thread actually is. For this, we will imagine a simple application with only a single button which downloads a file from the internet when clicked. The application already has one main thread which is used for the entire UI. On the Windows platform, this means sending/receiving Windows messages, drawing to a control canvas, recognizing user interaction, etc. This thread is essentially a giant loop which is spinning around really fast. For every revolution of this spinning thread, certain pieces of code are executed.

In a single threaded environment, this file download would block this loop from spinning, until the download is finished. During this time, this thread is no longer able to do any UI updates, detect user clicks, or anything. This is what causes Windows to put (Not Responding) in the title of such forms, because, well, just like it says, it's not responding.

This is where threads come in. It needs to respond to Windows. Instead of blocking the main UI thread with this giant file download, you could put that file download into a thread. It's just that simple, right?

## Not so much.

You may ask yourself "How do I monitor the progress?" or "How do I get notified when it's done?" This would mean the download thread needs to somehow interact with the main thread. This is exactly where the confusion comes in. One thread cannot simply interfere with another thread, because there's no telling at what point one thread is actually at. There's two separate loops now, and when you want to update the UI, that UI thread could be anywhere doing anything. Most importantly, suppose the main UI thread is in the process of writing a string to the same control property which your other thread also wants to write to. Now you have two threads attempting to write to the same memory address, which can result in unpredictable issues.

## So how do I do it then?

By synchronizing. Delphi's TThread class has a method Synchronize() which allows a thread to interact with the main UI thread only at a moment when it will actually behave properly, when it actually expects such an occurance. Code which is synchronized from another thread doesn't actually run in the context of that thread - it always runs in the context of the main UI thread. That's the idea of Synchronize(), is to execute code in the UI thread.

So in the end, you don't actually use the VCL from the thread. Instead, your thread sends a signal to the main thread, and only when the main thread is ready will it execute that code. Meanwhile, your secondary thread then gets blocked while it waits for the main thread to finish.

Then there's the mistake of thinking a large UI operation would be better off in a thread. Let's say you have a list where you want to populate millions of items. Of course that will take time, and during this time your application will be not responding. Again. So just move that code to a thread, right?

## Wrong.

Again, any UI interaction must be done from the main thread, and the main thread only. Threads are useful if you need to perform lengthy calculations, process massive amounts of data, wait for a response from a remote resource, or otherwise anything which is both time consuming and not directly related to the UI.

## How do I know if I'm doing it right?

That's hard to say. But there is a common practice which is highly advised when writing a thread: Put your thread code in a unit of its own. This unit should be isolated from any other UI unit. It should not even have any VCL related unit in its uses clause. The thread shouldn't even know how it's being used. It should be essentially a dummy, with the sole purpose of performing your lengthy task. When it comes to UI updates from a thread, this is best accomplished by synchronized events.

## What's a synchronized event?

Exactly what it sounds like. It's an event which is synchronized, as explained earlier. An event is simply a pointer to a procedure which you can assign to the thread before it starts. Inside the thread, when you need to update the UI, you would then use Synchronize() to trigger this event. With this design, the thread would never ever have to know that it's even being used by a UI. At the same time, you also inadvertently accomplish abstraction. The thread becomes re-usable. You can plug it into some other project which might not even have a user interface (let's say a Windows Service).

## Now for the sample code...

This project is still a work in progress, and I will soon be providing some sample code to demonstrate everything discussed here. Until then, there are literally thousands of resources out there covering this exact topic.

## Where else can I learn?

Here's some direct links to related resources about VCL Thread Safety, in case you don't want to search...

 - Embarcadero - Using the Main VCL Thread
 - Embarcadero - Delphi Threading by Example
 - Stack Overflow - Delphi: Why VCL is not thread-safe? How can be?
 - Dr. Bob - Is the VCL thread-safe?
 - ThoughtCo - Synchronizing Threads and GUI in a Delphi Application
