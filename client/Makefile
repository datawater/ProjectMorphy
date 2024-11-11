include ../config.mk

SRC_FILES := $(wildcard src/*.cpp)
OBJ_FILES := $(patsubst %.cpp,%.o,$(SRC_FILES))

.PHONY: main
main: comp_client

.PHONY: comp_server
comp_client: common client

client: $(OBJ_FILES)
	$(CXX) $(CXXFLAGS) $^ -o $@ -lh4common $(LIBS)

src/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(LIBS)

.PHONY: common
common:
	make -C ../common

.PHONY: clean
clean:
	-find . -type f -name "*.o" -delete
	-rm server
	-rm *.a