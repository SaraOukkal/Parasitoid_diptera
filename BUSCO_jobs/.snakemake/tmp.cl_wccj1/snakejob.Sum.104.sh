#!/bin/sh
# properties = {"type": "single", "rule": "Sum", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_914767935.1/BUSCO_results/run_arthropoda_odb10/full_table.tsv"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_914767935.1/BUSCO_results/Sum_table_GCA_914767935.1.txt"], "wildcards": {"Genome_ID": "GCA_914767935.1"}, "params": {"threads": "1", "time": "00:10:00", "name": "Sum_run_GCA_914767935.1"}, "log": [], "threads": 1, "resources": {}, "jobid": 104, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_914767935.1/BUSCO_results/Sum_table_GCA_914767935.1.txt --snakefile /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/Snakemake_BUSCO_QUAST_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.cl_wccj1 /beegfs/data/soukkal/StageM2/Control_genomes/results/Stat_Results/GCA_914767935.1/BUSCO_results/run_arthropoda_odb10/full_table.tsv --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Sum --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.cl_wccj1/104.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/BUSCO_jobs/.snakemake/tmp.cl_wccj1/104.jobfailed; exit 1)

