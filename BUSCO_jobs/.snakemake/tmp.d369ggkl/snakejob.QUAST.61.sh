#!/bin/sh
# properties = {"type": "single", "rule": "QUAST", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/leskia_janzen27.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/leskia_janzen27/QUAST_results/report.tsv"], "wildcards": {"Genome_ID": "leskia_janzen27"}, "params": {"threads": "5", "time": "00:20:00", "name": "QUAST_run_leskia_janzen27", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_leskia_janzen27.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_leskia_janzen27.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 61, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/leskia_janzen27/QUAST_results/report.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/leskia_janzen27.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules QUAST --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl/61.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl/61.jobfailed; exit 1)

