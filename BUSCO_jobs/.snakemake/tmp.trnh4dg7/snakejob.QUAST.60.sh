#!/bin/sh
# properties = {"type": "single", "rule": "QUAST", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/campylocheta_wood03.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/campylocheta_wood03/QUAST_results/report.tsv"], "wildcards": {"Genome_ID": "campylocheta_wood03"}, "params": {"threads": "5", "time": "00:40:00", "name": "QUAST_run_campylocheta_wood03", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_campylocheta_wood03.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/QUAST_LOGS/QUAST_job_campylocheta_wood03.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 60, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/campylocheta_wood03/QUAST_results/report.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.trnh4dg7 /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/campylocheta_wood03.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules QUAST --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.trnh4dg7/60.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.trnh4dg7/60.jobfailed; exit 1)
