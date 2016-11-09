
###在这里添加源文件目录
SRCDIR=	./\
		./robot/\

###这里定义目标文件目录
OBJDIR =./obj/

TARGET_NAME=node_robot

INCLUDE=-I/usr/local/include/nodelib/base\
		-I/usr/local/include/nodelib/network\
		-I/usr/local/include/nodelib/struct\
		-I/usr/local/include/nodelib/xml\
		$(addprefix -I, $(SRCDIR))

LIBDIR=-L./

LIB=-lnodelib\
	-lv8\
	-lv8_libplatform\
	-lcurl\
	-lcrypto\
	-lmysqlcppconn\
	-ljsoncpp\

BIN=./

CC=g++

DEPENDS=-MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)"

DEBUGFLAG=-O0 -g3 -Wall -c -fmessage-length=0 -std=c++11

RELEASEFLAG=-O3 -Wall -c -fmessage-length=0 -std=c++11

LDFLAG=

BIN_TARGET=$(OBJDIR)bin/$(TARGET_NAME)

SRCS=$(wildcard $(addsuffix *.cpp, $(SRCDIR)))

OBJECTS:=$(addprefix $(OBJDIR), $(subst ./,,$(SRCS:.cpp=.o)))

.PHONY: mkobjdir clean  

all: mkobjdir $(BIN_TARGET)

-include $(OBJECTS:.o=.d)

$(BIN_TARGET):$(OBJECTS)
	$(CC) $(LDFLAG) -o $@ $^ $(LIBDIR) $(LIB)
	@echo " "
	@echo "Finished building target: $(TARGET_NAME)"
	@echo " "
	@-cp -f $(BIN_TARGET) $(BIN)

$(OBJDIR)%.o:%.cpp
ifeq ($(MODE), DEBUG)
	@echo "Building DEBUG MODE target $@"
	$(CC) $(INCLUDE) $(DEBUGFLAG) $(DEPENDS) -o "$(@)" "$(<)"
else
	@echo "Building RELEASE MODE target $@"
	$(CC) $(INCLUDE) $(RELEASEFLAG) $(DEPENDS) -o "$(@)" "$(<)"
endif
	@echo " "

mkobjdir:
	@test -d $(OBJDIR) || (mkdir $(OBJDIR) && mkdir $(OBJDIR)bin $(addprefix $(OBJDIR), $(subst ./,,$(SRCDIR))))

clean:
	-rm -rf $(OBJDIR)
