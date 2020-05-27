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
        $(CXX) $(LDFLAGS) -o $@ $(OBJS)

run: all
    @./$(TARGET)COMPILER  = g++
CFLAGS    = -g -MMD -MP -Wall -Wextra -Winit-self -Wno-missing-field-initializers
ifeq "$(shell getconf LONG_BIT)" "64"
  LDFLAGS =
else
  LDFLAGS =
endif
LIBS      =
INCLUDE   = -I./include
TARGET    = ./bin/$(shell basename `readlink -f .`)
SRCDIR    = ./source
ifeq "$(strip $(SRCDIR))" ""
  SRCDIR  = .
endif
SOURCES   = $(wildcard $(SRCDIR)/*.cpp)
OBJDIR    = ./obj
ifeq "$(strip $(OBJDIR))" ""
  OBJDIR  = .
endif
OBJECTS   = $(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.cpp=.o)))
DEPENDS   = $(OBJECTS:.o=.d)

$(TARGET): $(OBJECTS) $(LIBS)
	$(COMPILER) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	-mkdir -p $(OBJDIR)
	$(COMPILER) $(CFLAGS) $(INCLUDE) -o $@ -c $<

all: clean $(TARGET)

clean:
	-rm -f $(OBJECTS) $(DEPENDS) $(TARGET)

-include $(DEPENDS)

.PHONY: depend clean
depend:
    $(CXX) $(INCLUDES) -MM $(SRCS) > $(DEPS)
    @sed -i -E "s/^(.+?)\1/\2\1.o: ([^ ]+?)\1/\2\2.o: \2\1/g"  $(DEPS)

clean:
    $(RM) $(OBJS) $(TARGET)

-include $(DEPS)
