# starcomplexity
An EcoLab project for exploring Star Complexity of Networks

# Clone repo and initialise dependencies
  * git clone https://github.com/highperformancecoder/starcomplexity.git
  * git submodule update --init --recursive

# Install Dependencies: cairo-devel, pango-devel, python3, OneAPI for GPU support

# To build:

    make -j
    make -j OPENMP=1 (SMP multithreading)
    make -j DPCPP=1  (GPU support via OneAPI. Additional compiler flags required for NVidia GPUs). Note the GPU build currently produces incorrect results for graphs of 7 stars or higher.

# To run:
  python3 starcomplexity.py

