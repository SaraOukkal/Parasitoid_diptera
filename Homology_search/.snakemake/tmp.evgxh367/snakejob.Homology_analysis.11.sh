#!/bin/sh
# properties = {"type": "single", "rule": "Homology_analysis", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_IVSPER", "/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCA_001735545.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCA_001735545.1/run_mmseqs2/result_mmseqs2.m8"], "wildcards": {"Genome_ID": "GCA_001735545.1"}, "params": {"threads": "10", "time": "48:00:00", "mem": "5G", "name": "Mmseqs2_GCA_001735545.1", "exclude": "pbil-deb6,pbil-deb7,pbil-deb8,pbil-deb9,pbil-deb10,pbil-deb11,pbil-deb12,pbil-deb13,pbil-deb14,pbil-deb15,pbil-deb16,pbil-deb17,pbil-deb18,pbil-deb19,pbil-deb27", "out": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCA_001735545.1_Mmseqs2_viral_search.out", "err": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCA_001735545.1_Mmseqs2_viral_search.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 11, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCA_001735545.1/run_mmseqs2/result_mmseqs2.m8 --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.evgxh367 /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_IVSPER /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCA_001735545.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Homology_analysis --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.evgxh367/11.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.evgxh367/11.jobfailed; exit 1)

