FROM ubuntu:16.04

RUN apt-get update && apt-get install -y vim zlib1g-dev patchelf \ 
libreadline-gplv2-dev  libncursesw5-dev libssl-dev libsqlite3-dev \
tk-dev libgdbm-dev libc6-dev libbz2-dev \
tk build-essential texinfo gawk bison flex tar \
wget gcc clang 

WORKDIR "/app"
COPY requirements.txt main.py res/ /app/deps/

RUN wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz && \
	tar -xzf Python-3.9.16.tgz && \
	rm Python-3.9.16.tgz &&  \
	cd Python-3.9.16 && \
	./configure --enable-optimizations && \
    	make -j$(nproc) && \
    	make install 

RUN pip3 install -r /app/deps/requirements.txt

RUN python3 -m nuitka --show-progress --onefile \
 --include-data-dir=$(pwd)/deps/res=res deps/main.py
