#!/bin/sh
# properties = {"type": "single", "rule": "BUSCO", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/chrysoexorista_wood04.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/chrysoexorista_wood04/BUSCO_results/run_arthropoda_odb10/full_table.tsv"], "wildcards": {"Genome_ID": "chrysoexorista_wood04"}, "params": {"threads": "3", "time": "2:00:00", "name": "BUSCO_run_chrysoexorista_wood04", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/BUSCO_LOGS/BUSCO_job_chrysoexorista_wood04.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/BUSCO_LOGS/BUSCO_job_chrysoexorista_wood04.error", "lineage": "arthropoda_odb10", "mode": "genome"}, "log": [], "threads": 1, "resources": {}, "jobid": 29, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Stat_Results/chrysoexorista_wood04/BUSCO_results/run_arthropoda_odb10/full_table.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/chrysoexorista_wood04.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules BUSCO --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl/29.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.d369ggkl/29.jobfailed; exit 1)

