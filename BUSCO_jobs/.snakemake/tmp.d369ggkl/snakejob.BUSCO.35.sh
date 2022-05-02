#!/bin/sh
# properties = {"type": "single", "rule": "BUSCO", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/cordyligaster_capellii.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/cordyligaster_capellii/BUSCO_results/run_arthropoda_odb10/full_table.tsv"], "wildcards": {"Genome_ID": "cordyligaster_capellii"}, "params": {"threads": "3", "time": "2:00:00", "name": "BUSCO_run_cordyligaster_capellii", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/BUSCO_LOGS/BUSCO_job_cordyligaster_capellii.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/BUSCO_LOGS/BUSCO_job_cordyligaster_capellii.error", "lineage": "arthropoda_odb10", "mode": "genome"}, "log": [], "threads": 1, "resources": {}, "jobid": 35, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/cordyligaster_capellii/BUSCO_results/run_arthropoda_odb10/full_table.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/cordyligaster_capellii.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules BUSCO --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl/35.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl/35.jobfailed; exit 1)

