# WonderRepo

A curated repository for building **WhirlyOS Linux**, based on Debian.

> **Copyright Notice:** I forked this repository from hirohamada2014, who is the original owner of WhirlyOS. hirohamada214 was my old GitHub account, but I moved to a new one and forked this repo.

WhirlyOS wraps a Linux base in a playful, ADHD-aware shell—complete with simple interfaces, and seamless access to browser-based learning tools across desktop and embedded platforms. It has the features of the screen time limit to keep you free from distraction and be healthy. 

> ### **Note:** I made lots of attempts to build WhirlyOS using 0x OS Builder. I have to test with Cubic next!
> 
> i386 compatibility releases only! 

---

## 🐧 Base Distribution

> [!WARNING]
> Development of WhirlyOS is still ongoing. Wait for a release.

WhirlyOS is based on **Debian Stable**, ensuring:

- 🔒 Rock-solid reliability
- 📦 Access to thousands of packages via APT
- 🛠️ Easy customization and community support
- 🧩 Compatibility with most hardware

---

## 🎬 Motto

> **Find your spark. Find your way.**

Inspired by *Soul* (2020), this motto reflects WhirlyOS’s mission to help users discover their passion through technology.  
It is not an official Disney or Pixar tagline and is safe to use.

---


## Desktop Envirnoments

| **Edition Name**   | **Desktop Environment** | **Inspired By**     | **Notes**                                      | **Reasons why it's called** |**Specs**                          |
|--------------------|--------------------------|---------------------|-----------------------------------------------| ------------------------------------------|------------------------------------|
| **SoulFrame**      | GNOME                    | *Soul*              | Dreamlike UI, celestial theme, Great Before    | The dream interface feels like perfect| 2 GB RAM, 20 GB disk, GPU optional |
| **MeiLite**        | XFCE                     | *Turning Red*       | Fast, expressive, lightweight                  | Since Turning Red is set in 2002, Xfce desktop is used in order to give the olden times | 1 GB RAM, 10 GB disk               |
| **ElementalDesk**  | KDE Plasma               | *Elemental*         | Vibrant, customizable, elemental UI            | The classical elements (not the elements of the periodic table) fit perfectly in Plasma | 4 GB RAM, 25 GB disk               |
| **NotebookOS**     | Openbox                  | *Luca*              | Minimal, seaside calm, fast boot               | Since, older time periods gave this perfect interface of the old BunsenLabs into WhirlyOS to the run | 512 MB RAM, 5 GB disk              |
| **QuestLand**      | Budgie                   | *Onward*            | Adventurous, magical, modern desktop           | For fantasy fans, this is the perfect desktop for them | 2 GB RAM, 15 GB disk               |
| **IntellSpace**    | LXQt                     | *Wall·E*            | Futuristic, efficient, low-resource            | Since the movie is released in 2008, LXQt gives teh Windows 7 interface back to life | 1 GB RAM, 8 GB disk                |
  
## 🎯 Goals

- 🧠 **Inspire creativity** through themed desktop environments based on beloved animated films
- 👨‍👩‍👧‍👦 **Support families** with built-in parental controls and screen time tools
- 💡 **Make computing magical** with custom UI elements, mascots, and cinematic flair
- 🐧 **Revive old hardware** with lightweight editions that run smoothly on low specs
- 🎨 **Celebrate diversity** in design, emotion, and user experience—just like Pixar’s characters
- 👨‍🎓 **For homeschooling, private and public schools** by giving educational tools (not in minimal) for help (without artificial intelligence)
  **Notes:** If anyone prefer doing homework (e.g. math) on physical notebooks, don't worry; you can use WhirlyOS for coding, or anything you can do in your computer as a technicial, or as exploring and surfing (with restrictions.)

---


## Features

- Minimal-clutter GNOME Shell with GDM login  
- Preinstalled learning apps: GCompris, Scratch, TuxMath, TuxPaint  
- Creative tools: GIMP, Mu Editor, MuseScore, VLC  
- Browser integrations for Google Classroom, Docs, Drive, YouTube Kids  
- Screen Time features  

---
## 📅 WhirlyOS Development Timeline (2025)

WhirlyOS is the latest chapter in a multi-year journey of OS experimentation and creativity. Here's how it evolved:

| **Month** | **Phase** | **Platform & Tools** | **Key Developments** |
|-----------|-----------|----------------------|-----------------------|
| **Jan 2025** | WhirlyOS building | Debian Linux | - Preparing to build WhirlyOS <br> via Debian Linux <br>- I also have to create assets. |




> Notes for release: No releases has been made as of 2026.

## How to install 

## Linux:

- A linux distro (any linux distro work)
- BalenaEtcher or DD command

## Windows:

- Windows 10/11 (or any version. Make sure they are compatible)
- Rufus, BalenaEtcher, or Win32Imager

## MacOS:

- macOS 10.15 or newer
- BalenaEtcher

## To install WhirlyOS on Windows:

> [!WARNING]
> Install at your own risk, as improper installation may result in warranty void. The owner of this operating system is not responsible for any damage done to the computer. Make sure in case of emergency to do a clean install of the original operating system.

If you use dual boot, you have to shrink your drive and create a partition with it. Be careful as you may break your device. The creator and WhirlyOS are not responsible for any damage.

On Windows:

1. Download your bootable usb creator from its official website.
2. Download WhirlyOS official iso disk image from the repository releases
3. Open the bootable usb creator
4. On Rufus: select your USB drive, select ISO disk image, and click Start. On Etcher: Select your USB drive, select ISO disk image, and click Flash.
5. After writing WhirlyOS to USB, restart your computer.
6. Enter Boot Manager (e.g. Del, F10, F12)
7. If Secure Boot is enabled, you may need to disable it. Otherwise, you will have a security violation.
8. Follow the onscreen instructions to setup WhirlyOS.

On Linux:

> You can use Etcher or dd, but it is recommended to use Etcher, because dd is advanced.

1. Download Etcher from its official website and install it.
2. Install WhirlyOS disk image
3. Follow steps 3 to 4 in the Windows section.
4. Follow steps 5 to 8.

To write WhirlyOS using the dd command, type this:

```bash

sudo dd if=path/to/your/whirlyOS.iso of=/dev/sdx bs=4M status=progress conv=fsync

```

> Note: The disk image name may vary.

   

---

## Building the ISO or Image
    
We don't support building WhirlyOS, but you may want to fork the repository.

---

## License

WhirlyOS is open-source under the MIT License. Anyone can fork this repo.

