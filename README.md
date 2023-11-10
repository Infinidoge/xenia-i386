# Xenia

## An OS written in C for the i386

An Operating Systems course project gone rogue, and the culmination of my work on [Infinidoge/os-tutorial](https://github.com/Infinidoge/os-tutorial), I've spun it off into its own repository.

## Source Structure

### [boot](./src/boot)

The boot loader, modified slightly from the original OS tutorial.

### [cpu](./src/cpu)

Code that interfaces directly with the CPU in one way or another.
This includes handling interrupts, managing the timer, and polling the processor for information.
Also includes a header file of common types, that will eventually be moved into `libc`.

### [drivers](./src/drivers)

As the name implies, these are drivers that handle different parts of interfacing with hardware.
The screen driver handles printing and drawing to the 80x25 text mode VGA interface that the OS runs in, while the keyboard driver handles keyboard input.

### [kernel](./src/kernel)

The root of the operating system, the kernel handles scheduling things to be run, as well as calling setup functions.
Anything that could be considered an "application" is also found here.

#### Applications

- The shell. The main interface to the operating system, it is the thing the OS boots into, and the gateway to everything else.
- Visualise. A sorting algorithm visualiser, supporting `bubble` for bubble sort, `insert` for insertion sort, `quick` for quick sort, and `merge` for merge sort.

### [libc](./src/libc)

Since I don't have access to `glibc`, I am re-implementing any standard-library pieces that I need in here.
I do have access to `libgcc` though, which I am making use of, primarily in the form of standard types.
Most notably, `mem` handles memory management (both naive and more properly implemented).

## Licensing

This repository is licensed under the [BSD 3-Clause license](./LICENSE.txt).
With that said though, I would appreciate it if you told me if you build off of my work, and make sure that you actually do something and learn something from it.
This is one of my passion projects, and something I am quite proud of.
I'd rather you not clone the repo, rename it to something else, and call it your own.
Thanks :)

Additionally, this project builds off of the work in [Carlos Fenollosa's original os-tutorial](https://github.com/cfenollosa/os-tutorial), and as such carries the same license.

## On the Name

This project is named after Xenia, an unofficial mascot for Linux, and a favorite of mine.
For more information about her and her story, check out [this site](https://xenia-linux-site.glitch.me)!
