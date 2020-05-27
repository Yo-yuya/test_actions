TARGET = app

SRCS  = $(shell find ./src      -type f -name *.cpp)
HEADS = $(shell find ./include  -type f -name *.h)
OBJS = $(SRCS:.cpp=.o)
DEPS = Makefile.depend

INCLUDES = -I./include
CXXFLAGS = -02  -Wall $(INCLUDES)
LDFLAGS = -1m

all: $(TARGET)

$(TARGET):  $(OBJS) $(HEADS)
    $(CXX)  $(LDFLAGS)  -o  $@ $(OBJS)

run: all
    @./$(TARGET)

.PHONY:depend clean
depend:
    $(CXX) $(INCLUDES) -MM $(SRCS) > $(DEPS)
    @sed -i -E "s/^(.+?)\1/\2\1.o: \2\1/g"  $(DEPS)

clean:
    $(RM)   $(OBJS) $(TARGET)

-include    $(DEPS)
