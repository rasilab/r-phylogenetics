
# base miniconda3 image
FROM continuumio/miniconda3:24.1.2-0

# install mamba installer for quick conda installations
RUN conda install mamba -c conda-forge

# Install Python packages in base environment 
RUN mamba install -y -c conda-forge jupyter 

# Install R conda environment
RUN mamba create -y -n R

RUN mamba install -y -n R -c conda-forge \
    r-tidyverse \
    r-janitor \
    r-irkernel \
    r-glue \
    r-devtools \
    r-plotrix \
    r-r.utils \
    r-ggrepel \
    r-ggthemes \
    r-ggridges \
    r-ggpubr 

RUN mamba install -y -n R -c bioconda -c conda-forge \
  bioconductor-plyranges \
  bioconductor-bsgenome.hsapiens.ucsc.hg38 \
  bioconductor-ggbio \
  bioconductor-ggtree \
  bioconductor-ggmsa

# Set up R jupyter kernel and make it visible to python
RUN /opt/conda/envs/R/bin/R -s -e "IRkernel::installspec(sys_prefix = T)"

# Make R visible to python environment
ENV PATH="$PATH:/opt/conda/envs/R/bin"

# install rasilab R templates
RUN /opt/conda/envs/R/bin/R -s -e "devtools::install_github('rasilab/rasilabRtemplates', ref = '0.4.0')"

# install dendextend package
RUN /opt/conda/envs/R/bin/R -s -e "install.packages('dendextend', repos='http://cran.rstudio.com/')"

# install dependencies for phytools
RUN mamba install -y -n R -c conda-forge r-igraph r-magick r-phangorn r-animation r-geiger

# install phytools from cran
RUN /opt/conda/envs/R/bin/R -s -e "install.packages('phytools', repos='http://cran.rstudio.com/')"