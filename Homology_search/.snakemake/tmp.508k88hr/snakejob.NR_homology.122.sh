#!/bin/sh
# properties = {"type": "single", "rule": "NR_homology", "local": false, "input": ["/beegfs/data/bguinet/these/NR_db"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Viral_loci/Candidate_viral_loci_Nr.m8"], "wildcards": {}, "params": {"threads": "10", "time": "48:00:00", "name": "NR_homology", "mem": "200G", "out": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/NR_homology.out", "err": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/NR_homology.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 122, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Viral_loci/Candidate_viral_loci_Nr.m8 --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.508k88hr /beegfs/data/bguinet/these/NR_db --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules NR_homology --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.508k88hr/122.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.508k88hr/122.jobfailed; exit 1)

