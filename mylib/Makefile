BUILD_DIR := output
INSTALL_DIR := /usr/local/lib


SRC := mytool.o
DTAR := libmytool.so
STAR := libmytool.a

DTARGET := $(BUILD_DIR)/$(DTAR)
STARGET := $(BUILD_DIR)/$(STAR)

CC := gcc

#CFLAGS := -I $(LIB_DIR)
#LDFLAGS := -ljson-c
#LIBS := -I/usr/local/include/json-c   -L/usr/local/lib/ 
FLAG := -fPIC -shared



slib:$(STARGET)

dlib:$(DTARGET)

all: dlib slib install

$(DTARGET):$(SRC)
	mkdir -p $(BUILD_DIR)	
	$(CC)  $^ $(FLAG) -o $@

$(STARGET):$(SRC)
	mkdir -p $(BUILD_DIR)	
	ar -rcv $@ $^

install:
	cp $(BUILD_DIR)/*.so $(INSTALL_DIR)/

clean:
	rm -rf $(BUILD_DIR) $(INSTALL_DIR)/$(DTAR) ./*.o*


.PHONY:clean install all dlib slib
