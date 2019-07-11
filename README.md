PPSSPP builder for iOS
======================

How to use it:
--------------

* cd to the ppsspp-builder folder and from the command line run:

        git clone https://github.com/hrydgard/ppsspp.git
        cd ppsspp
        git submodule update --init --recursive

* if you want to build an ipa
    * if you want to build a better compatibility version*
        
        set to use the early xcode command line tools like Xcode 9.4 (Xcode-Preference-Locations-Command Line Tools)
        then run:
        
            make ipa
            
        then change to use the latest xcode command line tools like Xcode 10.1
        and run:
        
            make ipa
            
    * if you want to build quickly

            make quickipa
            
* if you want to build an deb
    * if you want to build a better compatibility version*

        set to use the early xcode command line tools like Xcode 9.4 (Xcode-Preference-Locations-Command Line Tools)
then run:

            make deb

        then change to use the latest xcode command line tools like Xcode 10.1
and run:

            make deb
            
    * if you want to build quickly (or just use Xcode 9,4 to complete all compilation processes)

            make quickdeb

*Notice:
--------------
What means "a better compatibility version"?
    PPSSPP has three cpu cores to simulate psp and run our game -- interpreter Dynarec (JIT) IR interpreter. Among them, Dynarec (JIT) mode is the most efficient and can get better simulation results.
    It sounds pretty good? But what's wrong with this?
    Due to its closed nature, the iOS system is not allowed us directly called some function when we want to call. Some function can't even be called at all (Like Task_for_pid_0? :P). This is to protect the iOS system from malware, so Apple filters Some "safe and reliable" APIs are available for users/developers to call, and this includes JIT.
    So we have no way?
    No :P ,in fact, we have two ways to get around this limitation of Apple.
    In order to make it easier for developers to debug their applications, Apple will open up some additional functions for apps that are being debugged by xcode (even if they should not be used in the released app in their plan), which includes JIT! Yes, this is exactly what we need!
    But it is impossible for every player to use PPSSPP with a computer?
    Yes, so we need to fake a state and let the system think that "app is being debugged by xcode"
    We using syscall makes the system think "app is being debugged by xcode", so that players can use JIT even if they don't connect to the computer.
    Have any other problems?
    Unfortunately, yes. First, even if we call syscall in the code, if you use opactor to install ipa (whether or not you jailbreak), the get-task-allow entitlement in the PPSSPP main program will be destroyed - you will not be able to use JIT. (There have a bug in iOS11 which allowed you to simulate the xcode debug state without the get-task-allow entitlement, so you can still enable JIT).
    Even if you successfully use the system call to enable JIT, sometimes for some reason, iOS will always wait for signals from Xcode. It will make PPSSPP freezing when exit. When using cmake to build PPSSPP xcode project with iOS12 sdk, since the iOS12 SDK will add strange assertion code to the project, this will result in more frequent exit freezing. So we need to use iOS11 sdk and cmake to build PPSSPP xcode project. (It is important to note that this can only reduce the frequency of such problems, but not really solve the problem).
    It means build "a better compatibility version".
    If you want build quicker:
    You can just use the latest xcode command line tools to build everything. While this can be a problem for players who use syscall to call JIT, this has no effect on players who use Cydia Substrate to call JIT.
    Therefore, the best practice is to use the jailbreak tool that enables CS_DEBUGGED to jailbreak so that PPSSPP can enable JIT directly by calling Cydia Substrate.

What am I using:
--------------
* If you are not jailbreak
    Install ipa by using impactor -> not on iOS11 -> Can't use JIT
    Install ipa by using impactor -> on iOS11 -> Use syscall to use JIT
* If you are jailbreakd ;P
    Install ipa by using impactor -> not on iOS11 -> Can't use JIT
    Install ipa by using impactor -> on iOS11 -> Use syscall to use JIT
    Install ipa by using AppSync -> CS_DEBUGGED is opened -> Use Cydia Substrate to use JIT
    Install ipa by using AppSync -> CS_DEBUGGED is not opened -> Use syscall to use JIT
    Install deb -> CS_DEBUGGED is opened -> Use Cydia Substrate to use JIT
    Install deb -> CS_DEBUGGED is not opened -> Use syscall to use JIT

* Since I haven't used Substitute and I don't know how it works, I don't know how JIT will work on devices that used using Substitute's jailbreak tools (like Electra).

The last:
--------------
Due to my limited level, the above content may be incorrect or insufficient. Welcome to create issues or create pull requests. :P
