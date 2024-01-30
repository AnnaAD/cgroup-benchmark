all: matrix

CC=gcc
CFLAGS=-I.

%.o: %.c 
	$(CC) -c -o $@ $< $(CFLAGS)

matrix: matrix.o
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm *.o
	rm matrix

venv:
	python3 -m venv venv
	venv/bin/pip install numpy

python-matrix: venv
	venv/bin/python matrix.py 200