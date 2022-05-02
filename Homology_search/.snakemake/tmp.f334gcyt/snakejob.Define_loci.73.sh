#!/bin/sh
# properties = {"type": "single", "rule": "Define_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/cordyligaster_capellii/run_mmseqs2/result_mmseqs2.m8"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/cordyligaster_capellii/run_mmseqs2/result_mmseqs2_strand_V.m8", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/cordyligaster_capellii/run_mmseqs2/result_mmseqs2_strand_summary_V.bed"], "wildcards": {"Genome_ID": "cordyligaster_capellii"}, "params": {"threads": "3", "time": "08:00:00", "name": "Define_loci_cordyligaster_capellii", "out": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Define_loci_cordyligaster_capellii.out", "err": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Define_loci_cordyligaster_capellii.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 73, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/cordyligaster_capellii/run_mmseqs2/result_mmseqs2_strand_V.m8 --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.f334gcyt /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/cordyligaster_capellii/run_mmseqs2/result_mmseqs2.m8 --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Define_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.f334gcyt/73.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.f334gcyt/73.jobfailed; exit 1)

