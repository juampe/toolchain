# Multi-platform Docker GNU toolchain builder for bare-metal/embedded 👪
Initially made for RISC-V, this builder generates up to date toolchain for several architectures
# Build process. 🏗️

To build a toolchain is necesary some packages

```
sudo apt-get update
sudo apt-get -y install git make curl perl buildah

git clone https://github.com/juampe/toolchain.git
cd toolchain

#Adapt Makefile DOCKER_TAG to tag and fit your own docker registry
#Adapt Makefile ARCHS for multiple builds or use autosense build-* target
make

#For example to build riscv64-unwknow-elf with newlib
make build-unknown-newlib-riscv64
#For example to build arm64-unwknow-elf
make build-unknown-arm64
#For example to build xtensa-unwknow-elf with newlib
make build-unknown-newlib-xtensa
#For example to build amd64-unwknow-elf
make build-unknown-amd64

#For example to build riscv64-unwknow-elf for xuantie openc910 from xuantie toolchain
make build-xuantie
```

The resulted toolchain is stored in the repo directory

# 🙏Thanks 
To @avelinohm and his blog.
This procedure is based on this article.
http://avelinoherrera.com/blog/index.php?entry=entry210526-161939

To T-Head for not allow toolchain downloads out of china (Registered download + Force chinese phone number in registration process)

# Enjoy!🍿
# Appendix 🎁
## Build xuantie T-Head toolchain
```
~# sudo apt-get -y install git make curl perl buildah iverilog
~# git clone https://github.com/juampe/toolchain.git
~# cd toolchain
~# make build-xuantie
# The toolchain built is in the repo directory
~# sudo tar -C / -xvjf repo/toolchain-gcc-elf-newlib-xtheadc-riscv64-11.2.0.tbz2
~# /opt/toolchain/riscv64/bin/riscv64-unknown-elf-gcc --version
riscv64-unknown-elf-gcc (GCC) 10.2.0
```
## Make a runcase with iverilog
```
~# cd
~# git clone https://github.com/T-head-Semi/openc910.git
~# cd openc910/smart_run
~# export CODE_BASE_PATH=~/openc910/C910_RTL_FACTORY
~# export TOOL_EXTENSION=/opt/toolchain/riscv64/bin
~# mkdir -p work
~# make runcase CASE=hello_world 
make[1]: Entering directory '/root/openc910/smart_run'
make[1]: Leaving directory '/root/openc910/smart_run'
  [THead-smart] Compiling smart now ...
  [THead-smart] SIM = iverilog
  Toolchain path: /opt/toolchain/riscv64/bin
/bin/sh: 1: Syntax error: Bad fd number
make[2]: *** [setup/smart_cfg.mk:98: hello_world_build] Error 2
make[1]: *** [Makefile:175: buildcase] Error 2
make: *** [Makefile:196: runcase] Error 2
```
## Fix shell (bash) where it fails (smart_cfg.mk:98)
```
~# sed -i setup/smart_cfg.mk -e 's/>&/>/'
~# make runcase CASE=hello_world
make[1]: Entering directory '/root/openc910/smart_run'
make[1]: Leaving directory '/root/openc910/smart_run'
  [THead-smart] Compiling smart now ... 
  [THead-smart] SIM = iverilog
  Toolchain path: /opt/toolchain/riscv64/bin
cd ./work && vvp xuantie_core.vvp 
intc.c: In function 'ck_intc_init':
intc.c:19:34: warning: initialization of 'int *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   19 | #define APB_BASE                 0x10000000
      |                                  ^~~~~~~~~~
intc.c:25:14: note: in expansion of macro 'APB_BASE'
   25 |  int *picr = APB_BASE;
      |              ^~~~~~~~
intc.c:20:34: warning: initialization of 'int *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   20 | #define INTC_BASE                0x10010000
      |                                  ^~~~~~~~~~
intc.c:29:22: note: in expansion of macro 'INTC_BASE'
   29 |         int *piser = INTC_BASE + 0x10;
      |                      ^~~~~~~~~
vtimer.c: In function 'sim_end':
vtimer.c:31:12: warning: assignment to 'int *' from 'unsigned int' makes pointer from integer without a cast [-Wint-conversion]
   31 |   END_ADDR = 0xA001FF48;
      |            ^
vtimer.c:34:13: warning: unsigned conversion from 'long int' to 'unsigned int' changes value from '18324075042' to '1144205858' [-Woverflow]
   34 |   END_DATA= 0x444333222;
      |             ^~~~~~~~~~~
        ********* Init Program *********
        ********* Wipe memory to 0 *********
        ********* Read program *********
WARNING: ../logical/tb/tb.v:136: $readmemh: Standard inconsistency, following 1364-2005.
WARNING: ../logical/tb/tb.v:137: $readmemh: Standard inconsistency, following 1364-2005.
        ********* Load program to memory *********

Hello Friend!
Welcome to T-HEAD World!

a is 1!
b is 2!
c is 0!
!!! PASS !!!after ASM c is changed to 3!
**********************************************
*    simulation finished successfully        *
**********************************************

```


