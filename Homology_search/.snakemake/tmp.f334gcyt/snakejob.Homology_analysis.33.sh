#!/bin/sh
# properties = {"type": "single", "rule": "Homology_analysis", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_IVSPER", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/siphosturmia_rafaelidhj03.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/siphosturmia_rafaelidhj03/run_mmseqs2/result_mmseqs2.m8"], "wildcards": {"Genome_ID": "siphosturmia_rafaelidhj03"}, "params": {"threads": "10", "time": "48:00:00", "mem": "5G", "name": "Mmseqs2_siphosturmia_rafaelidhj03", "out": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/siphosturmia_rafaelidhj03_Mmseqs2_viral_search.out", "err": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/siphosturmia_rafaelidhj03_Mmseqs2_viral_search.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 33, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/siphosturmia_rafaelidhj03/run_mmseqs2/result_mmseqs2.m8 --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.f334gcyt /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_IVSPER /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/siphosturmia_rafaelidhj03.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Homology_analysis --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.f334gcyt/33.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.f334gcyt/33.jobfailed; exit 1)
