.PHONY : build all
LOCAL_ARCH:= $(shell docker version -f "{{.Server.Arch}}")
#To build several architectures add in this variable in space separated format
ARCHS:= riscv64
DOCKER_TAG := juampe/toolchain
DOCKER_SUBTAG := -lunar
UBUNTU := ubuntu:lunar
LATEST_TAG := $(DOCKER_TAG):latest
RELEASE_TAG := $(DOCKER_TAG):toolchain
#Release autodetect
BINUTILS := $(shell curl -s https://ftp.gnu.org/gnu/binutils/|grep "tar.gz<"|tail -1|perl -pe 's/^.*?>binutils-(.*).tar.gz.*/\1/')
GCC := $(shell curl -s https://ftp.gnu.org/gnu/gcc/|grep DIR|grep "gcc-"|tail -1|perl -pe 's/^.*?>gcc-(.*)\/<.*/\1/')
GMP := $(shell curl -s https://ftp.gnu.org/gnu/gmp/|grep "tar.bz2<"|tail -1|perl -pe 's/^.*?>gmp-(.*).tar.bz2.*/\1/')
MPC := $(shell curl -s https://ftp.gnu.org/gnu/mpc/|grep "tar.gz<"|tail -1|perl -pe 's/^.*?>mpc-(.*).tar.gz.*/\1/')
MPFR := $(shell curl -s https://ftp.gnu.org/gnu/mpfr/|grep "tar.gz<"|tail -1|perl -pe 's/^.*?>mpfr-(.*).tar.gz.*/\1/')
#Add GCC version as tag
ARCH_TAG := $(DOCKER_TAG):$(GCC)-$(ARCH)$(DOCKER_SUBTAG)
#Build out of the container
#BUILDAH_CACHE := -v $(PWD)/repo:/repo -v /opt/toolchain:/opt/toolchain
BUILDAH_CACHE := -v $(PWD)/repo:/repo
JOBS := -j1

all: build

show:
	@echo $(ARCH_TAG)

prune:
	buildah rm -a
	buildah rmi -a

repodir:
	mkdir repo || true

build: $(addprefix build-unknown-, $(ARCHS))

build-unknown-x86_64: repodir
	$(eval ARCH := "x86_64")
	$(eval ARCH_TAG := $(DOCKER_TAG):$(GCC)-$(ARCH)$(DOCKER_SUBTAG))
	buildah bud $(BUILDAH_CACHE) --format docker --layers --platform linux/$(LOCAL_ARCH) --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg TOOLTARGET=$(ARCH)-unknown-elf  --build-arg BINUTILS=$(BINUTILS) --build-arg GCC=$(GCC) --build-arg MPC=$(MPC) --build-arg MPFR=$(MPFR) -t $(ARCH_TAG) -f Dockerfile.x86_64 .

build-unknown-%: repodir
	$(eval ARCH := $(subst build-unknown-,,$@))
	$(eval ARCH_TAG := $(DOCKER_TAG):$(GCC)-$(ARCH)$(DOCKER_SUBTAG))
	buildah bud $(BUILDAH_CACHE) --format docker --layers --platform linux/$(LOCAL_ARCH) --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg TOOLTARGET=$(ARCH)-unknown-elf  --build-arg BINUTILS=$(BINUTILS) --build-arg GCC=$(GCC) --build-arg MPC=$(MPC) --build-arg MPFR=$(MPFR) -t $(ARCH_TAG) -f Dockerfile.march .

build-unknown-newlib-%: repodir
	$(eval ARCH := $(subst build-unknown-newlib-,,$@))
	$(eval ARCH_TAG := $(DOCKER_TAG):$(GCC)-$(ARCH)$(DOCKER_SUBTAG))
	buildah bud $(BUILDAH_CACHE) --format docker --layers --platform linux/$(LOCAL_ARCH) --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg TOOLTARGET=$(ARCH)-unknown-elf  --build-arg BINUTILS=$(BINUTILS) --build-arg GCC=$(GCC) --build-arg MPC=$(MPC) --build-arg MPFR=$(MPFR) -t $(ARCH_TAG) -f Dockerfile.march.newlib .

build-xuantie: repodir
	$(eval ARCH := "riscv64")
	$(eval ARCH_TAG := $(DOCKER_TAG):$(GCC)-$(ARCH)$(DOCKER_SUBTAG))
	buildah bud $(BUILDAH_CACHE) --format docker --layers --platform linux/$(LOCAL_ARCH) --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg TOOLTARGET=$(ARCH)-unknown-elf -t $(ARCH_TAG) -f Dockerfile.openc910 .
