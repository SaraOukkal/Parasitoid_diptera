#!/bin/sh
# properties = {"type": "single", "rule": "BUSCO", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Hymenoptera_genomes/genomes/GCA_009823575.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Stat_Results/GCA_009823575.1/BUSCO_results/run_hymenoptera_odb10/full_table.tsv"], "wildcards": {"Genome_ID": "GCA_009823575.1"}, "params": {"threads": "3", "time": "10:00:00", "name": "BUSCO_run_GCA_009823575.1", "out": "/beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Stat_Results/BUSCO_LOGS/BUSCO_job_GCA_009823575.1.out", "err": "/beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Stat_Results/BUSCO_LOGS/BUSCO_job_GCA_009823575.1.error", "lineage": "hymenoptera_odb10", "mode": "genome"}, "log": [], "threads": 1, "resources": {}, "jobid": 4, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Stat_Results/GCA_009823575.1/BUSCO_results/run_hymenoptera_odb10/full_table.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Hymenoptera \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.8142ycmm /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/genomes/GCA_009823575.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules BUSCO --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.8142ycmm/4.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.8142ycmm/4.jobfailed; exit 1)

