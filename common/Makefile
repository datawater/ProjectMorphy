include ../config.mk

SRC_FILES := $(wildcard ./*.cpp)
OBJ_FILES := $(patsubst %.cpp,%.o,$(SRC_FILES))

libh4common.a: $(OBJ_FILES)
	ar -crs $@ $^

./%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: clean
clean:
	-find . -type f -name "*.o" -delete
	-rm *.a