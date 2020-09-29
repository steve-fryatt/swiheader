SWI Headers
===========

Make and install an AsASM-compatible SWI header.


Introduction
------------

SWI Headers can create and install an ObjASM or AsASM header file containing SWI name definitions, using the modules present on a RISC OS system.

As supplied, it contains a pre-built file with the SWIs necessary to build the associated projects. In addition, with access to a RISC OS system, the MakeHeader program can scrape the SWI details from active modules and produce a full header.


Installation
------------

To install and use SWI Headers, it will be necessary to have suitable Linux system with a working installation of the [GCCSDK](http://www.riscos.info/index.php/GCCSDK).

To build MakeHeaders and install the supplied headers file, use

	make install

from the root folder of the project. This will tokenise the MakeHeaders program, and also copy a pre-built header file with the SWIs necessary for other projects into to the GCCSDK environment. This is all that is required in order to use the headers for building other projects.

To use MakeHeader to generate a new list of SWI names, it will be necessary to have access to a RISC OS system. If the Linux build folder can be accessed from RISC OS (eg. via Sunfish, HostFS or similar), run MakeHeader by double-clicking on it in the build folder -- it will update the AsmSWINames file to contain details of the SWIs present on the machine.

Alternatively, copy MakeHeader and HeadTempl from the build folder into a folder on a RISC OS system, run MakeHeader as above, then copy the resulting AsmSWINames file back.


Original context
----------------

The template header contains ASM definitions and macros from the RISC OS sources, which can be found in the RISC OS Open Ltd GitLab repository. Two files are referenced:

* [/hdr/RISCOS](https://gitlab.riscosopen.org/RiscOS/Sources/Kernel)
* [/hdr/Macros](https://gitlab.riscosopen.org/RiscOS/Sources/Programmer/HdrSrc)


Licence
-------

SWI Headers is licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "**as is**" basis, **without warranties or conditions of any kind**, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
