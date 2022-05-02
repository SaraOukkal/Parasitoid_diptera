#!/bin/sh
# properties = {"type": "single", "rule": "Define_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_001015335.1/run_mmseqs2/result_mmseqs2.m8"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_001015335.1/run_mmseqs2/result_mmseqs2_strand_V.m8", "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_001015335.1/run_mmseqs2/result_mmseqs2_strand_summary_V.m8"], "wildcards": {"Genome_ID": "GCF_001015335.1"}, "params": {"threads": "3", "time": "08:00:00", "name": "Define_loci_GCF_001015335.1", "out": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Define_loci_GCF_001015335.1.out", "err": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Define_loci_GCF_001015335.1.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 75, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_001015335.1/run_mmseqs2/result_mmseqs2_strand_V.m8 --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.j1_a1y_2 /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_001015335.1/run_mmseqs2/result_mmseqs2.m8 --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Define_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.j1_a1y_2/75.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.j1_a1y_2/75.jobfailed; exit 1)

