CC = gcc

# User-space source files (exclude monitor.c)
src = $(filter-out monitor.c,$(wildcard *.c))
target = $(src:.c=)

# Kernel module
obj-m += monitor.o

KDIR = /lib/modules/$(shell uname -r)/build
PWD  = $(shell pwd)

all: user module

# ✅ FIXED: compile each file separately
user:
	for file in $(src); do \
		$(CC) -o $${file%.c} $$file -lpthread; \
	done

# Kernel module
module:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	rm -f $(target)
	$(MAKE) -C $(KDIR) M=$(PWD) clean
