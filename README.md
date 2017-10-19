# Cmd Loves Bash (AKA bashex -> bash + executable)

There once was a little boy named cmd.exe and a little girl named bash... Windows pulled them apart, but today they are brought together. #LoveWins

## Executing .exe from bash

> **NOTE:** WSL in Windows 10 Creators Update (version 1703) can natively launch Windows programs from bash. You can use `bashex` if you want to use WSL on Windows 10 Anniversary Update (version 1607).

The initial versions of Windows Subsystem for Linux (WSL) had no way to execute `.exe` applications from the bash command line. If you wish to run an exe app from your current working directory in bash you must exit, cd into your former location, run your exe and then start bash up again. This was annoying and this project was intended to fix it. 

## Setup

### Part 1: Setup basic environment

Here is what you need to do:
1. Clone this repo into the root level of your C: Drive (the enclosing folder should be called "CmdLovesBash"). 
2. Add this new CmdLovesBash to your windows PATH
3. Add the following lines to your ~/.bash_aliases: alias cdexit="/mnt/c/CmdLovesBash/bashLovesCmd.sh
4. Presto! You can now access 'bashex' from the command line by enterring bashex. You can exit bashex with "exit" you can exit and cd into your current bash working directory with cdexit (the logic behind cdexit is what powers the upcoming magic).

### Part 2: Alias your desired exe commands into the bashex system

In order to execute exe from bash simply add another line into your "~/.bash_aliases . Because I use VS code every day (the application behind my primary frustration) let me use it as my demo exe. VS Code can open your current working directory in cmd.exe with the command "code .", all we need to do is then enter the following line into our aliases file:
> alias code="/mnt/c/CmdLovesBash/bashLovesCmd.sh code"

From now on everytime you enter 'code [args]' into the bash prompt our bashex helper script will be called which will exit bash, cd into your current working directory, execute code (with your desired paramters applied) and then return to your current location in bashex. 

Simply add any exe cmd that you desired following the format: 'alias command="/mnt/c/CmdLovesBash/bashLovesCmd.sh command"' to enable the same for your desired command.

## TODO

The primary action item left is to place a checksum in the CmdQueue.temp file to alert the bashex shell script whether bashex created the current bash instance. Because all of our bashex aliases are aliased in the environment they can freely be called in any instance of bash. The problem is that although they can be called they will not actually work because there will be no bashex wrapper which bash will fall in to on exit. For the time being a simple info message is being displayed to alert the user that the aliased cmd expects the current instance of bash to be bashex instantiated.
All other relevant todos are annoted in the src with 'TODO'

## DISCLAIMERS

If you decide to contribute to bashex be careful using the cmdlet when you are in the current working directory of the bashex local repo. All calls to bashex will reference your local copy instead of the official global copy.

Because of how Powershell interacts with cmd.exe, PS does not support bashex @ this time. If it is found to be beneficial this functionality can easily be added with the creation of a bashex.ps1 file. 

In addition, do to the security restrictions of powershell,if a bashex.ps1 port was made it would need to be launched with '.\bashex'. This is because you cannot launch a powershell script without specifying the directory of the script (this is in order to prevent malicious overrides of commonly used cmdlerts - http://superuser.com/a/695624).
