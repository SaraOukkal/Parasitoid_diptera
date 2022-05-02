#!/bin/sh
# properties = {"type": "single", "rule": "Define_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_pallida/run_mmseqs2/result_mmseqs2.m8"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_pallida/run_mmseqs2/result_mmseqs2_strand_V.m8", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_pallida/run_mmseqs2/result_mmseqs2_strand_summary_V.bed"], "wildcards": {"Genome_ID": "houghia_pallida"}, "params": {"threads": "3", "time": "08:00:00", "name": "Define_loci_houghia_pallida", "out": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Define_loci_houghia_pallida.out", "err": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Define_loci_houghia_pallida.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 52, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_pallida/run_mmseqs2/result_mmseqs2_strand_V.m8 --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.9ty3gxst /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_pallida/run_mmseqs2/result_mmseqs2.m8 --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Define_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.9ty3gxst/52.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.9ty3gxst/52.jobfailed; exit 1)

