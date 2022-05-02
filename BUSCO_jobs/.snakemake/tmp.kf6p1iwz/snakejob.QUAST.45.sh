#!/bin/sh
# properties = {"type": "single", "rule": "QUAST", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCA_001015075.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_001015075.1/QUAST_results/report.tsv"], "wildcards": {"Genome_ID": "GCA_001015075.1"}, "params": {"threads": "5", "time": "00:20:00", "name": "QUAST_run_GCA_001015075.1", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCA_001015075.1.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_GCA_001015075.1.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 45, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_001015075.1/QUAST_results/report.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.kf6p1iwz /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCA_001015075.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules QUAST --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.kf6p1iwz/45.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.kf6p1iwz/45.jobfailed; exit 1)

