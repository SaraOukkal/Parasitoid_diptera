#!/bin/sh
# properties = {"type": "single", "rule": "BUSCO", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_000699065.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/GCF_000699065.1/BUSCO_results/full_table.tsv"], "wildcards": {"Genome_ID": "GCF_000699065.1"}, "params": {"threads": "3", "time": "2:00:00", "name": "BUSCO_run_GCF_000699065.1", "out": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/BUSCO_LOGS/BUSCO_job_GCF_000699065.1.out", "err": "/beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/BUSCO_LOGS/BUSCO_job_GCF_000699065.1.error", "lineage": "arthropoda_odb10", "mode": "genome"}, "log": [], "threads": 1, "resources": {}, "jobid": 33, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/GCF_000699065.1/BUSCO_results/full_table.tsv --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.xujt8xt6 /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_000699065.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules BUSCO --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.xujt8xt6/33.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.xujt8xt6/33.jobfailed; exit 1)

