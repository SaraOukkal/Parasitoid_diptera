#!/bin/sh
# properties = {"type": "single", "rule": "QUAST", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_000347755.3.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCF_000347755.3/QUAST_results/report.tsv"], "wildcards": {"Genome_ID": "GCF_000347755.3"}, "params": {"threads": "5", "time": "00:40:00", "name": "QUAST_run_GCF_000347755.3", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCF_000347755.3.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCF_000347755.3.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 72, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCF_000347755.3/QUAST_results/report.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.elfvb3g3 /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_000347755.3.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules QUAST --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.elfvb3g3/72.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.elfvb3g3/72.jobfailed; exit 1)

