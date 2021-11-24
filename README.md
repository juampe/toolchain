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

#For example to build riscv64-unwknow-elf
make build-riscv64
#For example to build arm64-unwknow-elf
make build-arm64
#For example to build xtensa-unwknow-elf
make build-xtensa

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
