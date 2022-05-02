#!/bin/sh
# properties = {"type": "single", "rule": "QUAST", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCA_003055125.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_003055125.1/QUAST_results/report.tsv"], "wildcards": {"Genome_ID": "GCA_003055125.1"}, "params": {"threads": "5", "time": "00:40:00", "name": "QUAST_run_GCA_003055125.1", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCA_003055125.1.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCA_003055125.1.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 51, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_003055125.1/QUAST_results/report.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.wbsja709 /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCA_003055125.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules QUAST --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.wbsja709/51.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.wbsja709/51.jobfailed; exit 1)

