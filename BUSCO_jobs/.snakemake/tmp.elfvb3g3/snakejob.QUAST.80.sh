#!/bin/sh
# properties = {"type": "single", "rule": "QUAST", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_016617805.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCF_016617805.1/QUAST_results/report.tsv"], "wildcards": {"Genome_ID": "GCF_016617805.1"}, "params": {"threads": "5", "time": "00:40:00", "name": "QUAST_run_GCF_016617805.1", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCF_016617805.1.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCF_016617805.1.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 80, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCF_016617805.1/QUAST_results/report.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.elfvb3g3 /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_016617805.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules QUAST --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.elfvb3g3/80.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.elfvb3g3/80.jobfailed; exit 1)

